//Currently hardcoded for prod environment


resource "kubernetes_namespace" "gocd-agent" {
  metadata {
    name = "gocd-agent"
  }
}

// Add service account for goagent on production cluster so it can run kubectl etc. 
resource "google_service_account" "prod_go_agent" {
  depends_on = ["kubernetes_namespace.gocd-agent"]

  account_id   = "prod-go-agent"

  display_name = "Go Agent in Prod environment"
  // Run local-exec because terraform as 0.10 doesn't have a way to export it
  // https://github.com/terraform-providers/terraform-provider-google/pull/204
  provisioner "local-exec" {
       command = "gcloud beta iam service-accounts keys create --iam-account ${google_service_account.prod_go_agent.email}         service-account.json; kubectl --namespace ${kubernetes_namespace.gocd-agent.metadata.0.name} create secret generic google-service-account --from-file service-account.json; echo rm service-account.json"
  }
}

resource "google_project_iam_policy" "project" {
  project     = "${var.google_project}"
  policy_data = "${data.google_iam_policy.srv_account_policy.policy_data}"
}

data "google_iam_policy" "srv_account_policy" {
  binding {
    role = "roles/editor"

    members = [
      "serviceAccount:${google_service_account.prod_go_agent.email}",
    ]
  }
}

// Create secret with ssh keys
resource "kubernetes_secret" "ssh_key" {
  metadata {
    name = "ssh-key"
    namespace = "${kubernetes_namespace.gocd-agent.metadata.0.name}"
  }

  data {
    id_rsa = "${file("${data.terraform_remote_state.gocd-server.ssh_key_path}/id_rsa")}"
    id_rsa.pub  = "${file("${data.terraform_remote_state.gocd-server.ssh_key_path}/id_rsa.pub")}"
  }
}


data "template_file" "k8s" {
  template = "${file("${path.module}/k8sgoagent.tpl")}"

  vars {
    google_project  = "${var.google_project}"
    go_url          = "${data.terraform_remote_state.gocd-server.url}"
    go_auto_reg     = "${data.terraform_remote_state.gocd-server.auto_reg}"
 
  }
}
// Begin with some hardcoded values in goagent.yaml to get it up and running. 
module "kubernetes_goagent" {
  source        = "../kubernetes_beta"
  namespace   = "${kubernetes_namespace.gocd-agent.metadata.0.name}"
  k8sconf     = "${data.terraform_remote_state.gke.k8sconf}"
 // configuration = "${file("${path.module}/goagent.yaml")}"
  configuration = "${data.template_file.k8s.rendered}"
  depends_on  = "${google_service_account.prod_go_agent.unique_id} ${kubernetes_secret.ssh_key.generation}"
}