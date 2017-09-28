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
       command = "gcloud --project ${var.google_project} container clusters get-credentials ${data.terraform_remote_state.gke.name}; gcloud beta iam service-accounts keys create --iam-account ${google_service_account.prod_go_agent.email}         service-account.json; kubectl --namespace ${kubernetes_namespace.gocd-agent.metadata.0.name} create secret generic google-service-account --from-file service-account.json; echo rm service-account.json"
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "gcloud --project ${var.google_project} container clusters get-credentials ${data.terraform_remote_state.gke.name}; kubectl --namespace ${kubernetes_namespace.gocd-agent.metadata.0.name} delete secret google-service-account || /bin/true"
  }
}


resource "google_project_iam_member" "owner" {
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.prod_go_agent.email}"
}
/* Make go agent owner of the project so it can create and enable everything needed.

resource "google_project_iam_member" "iam_admin" {
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.prod_go_agent.email}"
}

resource "google_project_iam_member" "storage" {
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.prod_go_agent.email}"
}
*/

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

// Create configmap containing terragrunt config to be runned in the container
resource "kubernetes_config_map" "terragrunt_conf" {
  metadata {
    name = "terragrunt-conf"
    namespace = "${kubernetes_namespace.gocd-agent.metadata.0.name}"
  }

  data {
    terraform.tfvars = "${file("${var.terragrunt_config_path}/terraform.tfvars")}"
  }
}
data "template_file" "k8s" {
  template = "${file("${path.module}/k8sgoagent.tpl")}"

  vars {
    google_project  = "${var.google_project}"
    go_url          = "${data.terraform_remote_state.gocd-server.url}"
    go_auto_reg     = "${data.terraform_remote_state.gocd-server.auto_reg}"
    service_account = "${google_service_account.prod_go_agent.email}"
    registry        = "${var.gcr_host}"
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