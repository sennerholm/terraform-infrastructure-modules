data "helm_repository" "mikan" {
  name = "mikan"
  url  = "https://sennerholm.github.io/helm-charts/"
}

resource "helm_release" "vote" {
  name       = "vote"
  repository = "${data.helm_repository.mikan.metadata[0].name}"
  chart      = "mikan/azure-vote"
  #chart      = "mikan/azure-vote-osba"
  namespace = "${var.resourcegroup_name}-vote"

  set {
    name  = "rbac.create"
    value = "true"
  }
}
