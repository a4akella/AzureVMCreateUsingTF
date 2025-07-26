# AzureVMCreateUsingTF

main.tf file contains the definitions of resources, and their properties can refer to variables using the var.<name> syntax.

When terraform plan or terraform apply runs, Terraform resolves variable values.

Variable definitions (type, default, description) are typically declared in a file like variables.tf.

The type of each variable is defined in the variables.tf file using the type argument (e.g., type = string, type = list(string)).

The values for these variables are usually provided in a terraform.tfvars file or passed via the CLI or environment variables.

If no value is provided in terraform.tfvars or through other means, and a default value is specified in variables.tf, then the default is used.

Note -

If a required variable has no default value defined and is not provided, Terraform will prompt us to provide one at runtime.

Terraform doesn't require the filenames to be main.tf, variables.tf, or terraform.tfvars — these are just conventions.

Terraform automatically loads:

  1) terraform.tfvars (if it exists)
              *.auto.tfvars files
