output "user_data" {
    value = data.template_file.user_data_bootstrap.rendered
}

output "encoded_user_data" {
    value = base64encode(data.template_file.user_data_bootstrap.rendered)
}