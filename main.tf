resource "null_resource" "compile_template" {
  triggers = {
    always_run = "${filesha256("template.bicep")}"
  }
  provisioner "local-exec" {
    command = "az bicep build -f ./template.bicep --outfile ./template.json"
  }
}

data "local_file" "compiled_template" {
  filename = "./template.json"
  depends_on = [
    null_resource.compile_template
  ]
}

resource "azurerm_resource_group" "our_rg" {
  name = "${var.name_prefix}_rg"
  location = var.location
}
  
resource "azurerm_resource_group_template_deployment" "template" {
    name = "tf-deploy" # This should always be a static name, otherwise a deletion of the template resources might be triggered.
    resource_group_name = azurerm_resource_group.our_rg.name
    deployment_mode = "Incremental"
    parameters_content = jsonencode(
        {
            "namePrefix" = {
                value = var.name_prefix
            }
        }
    )
    template_content = data.local_file.compiled_template.content
}