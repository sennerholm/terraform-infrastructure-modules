
// Create new namespace 
resource "kubernetes_namespace" "todo_backend" {
  metadata {
    name = "${var.environment}-todo-backend${var.namespace_suffix}"
    //name = "arga"
  }
}

// Create inbound services
resource "kubernetes_service" "todo_backend" {
  metadata {
    name = "todo-backend"
    namespace = "${kubernetes_namespace.todo_backend.metadata.0.name}"
  }
  spec {
    selector {
      app = "backend"
    }
    session_affinity = "None"
    port {
      port = 80
      target_port = 3333
    }
    type = "LoadBalancer"
  }
}

// Create service account
resource "google_service_account" "todo_account" {
  depends_on = ["kubernetes_namespace.todo_backend"]

  account_id   = "${kubernetes_namespace.todo_backend.metadata.0.name}"

  display_name = "Todo Backend service account in ${var.environment} "
  // Run local-exec because terraform as 0.10 doesn't have a way to export it
  // https://github.com/terraform-providers/terraform-provider-google/pull/204
  provisioner "local-exec" {
       command = "gcloud --project ${var.google_project} container clusters get-credentials ${data.terraform_remote_state.gke.name}; gcloud beta iam service-accounts keys create --iam-account ${google_service_account.todo_account.email} service-account.json; kubectl --namespace ${kubernetes_namespace.todo_backend.metadata.0.name} create secret generic google-service-account --from-file service-account.json; echo rm service-account.json"
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "gcloud --project ${var.google_project} container clusters get-credentials ${data.terraform_remote_state.gke.name}; kubectl --namespace ${kubernetes_namespace.todo_backend.metadata.0.name} delete secret google-service-account"
  }
}

resource "google_project_iam_member" "datastore" {
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.todo_account.email}"
}
// Create Deployment

data "template_file" "k8s" {
  template = "${file("${path.module}/k8s-todo-backend.tpl")}"

  vars {
    google_datastore_namespace = "${kubernetes_namespace.todo_backend.metadata.0.name}"
    google_project             = "${var.google_project}"
    registry_host              = "${var.registry_host}"
    version                    = "${var.version}"

  }
}
// Begin with some hardcoded values in todo_backend.yaml to get it up and running. 
module "kubernetes_todo_backend" {
  source        = "../kubernetes_beta"
  namespace   = "${kubernetes_namespace.todo_backend.metadata.0.name}"
  k8sconf     = "${data.terraform_remote_state.gke.k8sconf}"
 // configuration = "${file("${path.module}/todo_backend.yaml")}"
  configuration = "${data.template_file.k8s.rendered}"
  depends_on  = ""
}