# Variables
TF_DIR := terraform/cluster
TF_PLAN := plan.out

# Targets
.PHONY: init plan apply destroy

init:
	cd $(TF_DIR) && terraform init

plan:
	cd $(TF_DIR) && terraform plan -target=helm_release.strimzi -out=$(TF_PLAN)

apply:
	cd $(TF_DIR) && terraform apply -auto-approve -target=helm_release.strimzi && terraform apply -auto-approve  

destroy:
	cd $(TF_DIR) && terraform destroy

fmt:
	cd $(TF_DIR) && terraform fmt

clean:
	rm -f $(TF_DIR)/$(TF_PLAN)