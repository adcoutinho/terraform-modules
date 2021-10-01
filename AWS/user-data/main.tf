data "template_file" "user_data_bootstrap" {
    template = file("${path.module}/templates/user_Data_bootstrap.sh")
    vars = {
        instance_domain_name        = var.instance_domain_name
    }
}