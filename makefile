# Variables
TF_DIR := terraform/cluster
TF_PLAN := plan.out

# Targets
.PHONY: init plan apply destroy

init:
	cd $(TF_DIR) && terraform init

plan:
	cd $(TF_DIR) && terraform plan -out=$(TF_PLAN)

apply:
	cd $(TF_DIR) && terraform apply $(TF_PLAN)

destroy:
	cd $(TF_DIR) && terraform destroy

clean:
	rm -f $(TF_DIR)/$(TF_PLAN)