// Temporary output
output "template" 
{
	value = "${data.template_file.k8s.rendered}"	
}