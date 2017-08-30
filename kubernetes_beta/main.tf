resource "null_resource" "kubernetes_resource" {
  triggers {
    configuration = "${var.configuration}"
  }

  provisioner "local-exec" {
    command = "touch ${path.module}/kubeconfig"
  }

  provisioner "local-exec" {
    command = "echo '${var.k8sconf["ca_certificate"]}' > ${path.module}/ca.pem"
  }
  provisioner "local-exec" {
    command = "echo '${var.k8sconf["client_certificate"]}' > ${path.module}/client.pem"
  }
  provisioner "local-exec" {
    command = "echo '${var.k8sconf["client_key"]}' > ${path.module}/client.key"
  }


  provisioner "local-exec" {
    command = "kubectl apply --kubeconfig=${path.module}/kubeconfig --server=${var.k8sconf["endpoint"]} --certificate-authority=${path.module}/ca.pem --client-certificate=${path.module}/client.pem --client-key=${path.module}/client.key --username=${var.k8sconf["username"]} --password=${var.k8sconf["password"]} --namespace=${var.namespace} -f - <<EOF\n${var.configuration}\nEOF"
  }
  // Cleanup files
  provisioner "local-exec" {
    command = "rm ${path.module}/client.key ${path.module}/client.pem ${path.module}/ca.pem"
  }
  // We need the files also when destroying, but I haven't find out the syntax for "when" if it's possible to 
  // declare them on both "destroy" and default
  provisioner "local-exec" {
    command = "touch ${path.module}/kubeconfig"
    when    = "destroy"
  }
  provisioner "local-exec" {
    command = "echo '${var.k8sconf["ca_certificate"]}' > ${path.module}/ca.pem"
    when    = "destroy"
  }
  provisioner "local-exec" {
    command = "echo '${var.k8sconf["client_certificate"]}' > ${path.module}/client.pem"
    when    = "destroy"
  }
  provisioner "local-exec" {
    command = "echo '${var.k8sconf["client_key"]}' > ${path.module}/client.key"
    when    = "destroy"
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete --kubeconfig=${path.module}/kubeconfig --server=${var.k8sconf["endpoint"]} --certificate-authority=${path.module}/ca.pem --client-certificate=${path.module}/client.pem --client-key=${path.module}/client.key --username=${var.k8sconf["username"]} --password=${var.k8sconf["password"]} --namespace=${var.namespace} -f - <<EOF\n${var.configuration}\nEOF"
  }

  provisioner "local-exec" {
    command = "rm ${path.module}/client.key ${path.module}/client.pem ${path.module}/ca.pem"
    when    = "destroy"
  }
}
