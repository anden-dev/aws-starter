include Makefile.settings

.PHONY: roles environment generate deploy delete

roles:
	${INFO} "Installing Ansible roles from roles/requirements.yml..."
	ansible-galaxy install -r roles/requirements.yml --force
	${INFO} "Installation complete"

generate/%:
	${INFO} "Generating templates for $*..."
	ansible-playbook site.yml -e 'Stack.Upload=false' -e 'Sts.Disabled=true' -e env=$* $(FLAGS) --tags generate
	${INFO} "Generation complete"

deploy/%:
	${INFO} "Deploying environment $*..."
	ansible-playbook site.yml -e env=$* $(FLAGS)
	${INFO} "Deployment complete"

delete/%:
	${INFO} "Deleting environment $*..."
	ansible-playbook site.yml -e env=$* -e 'Stack.Delete=true' $(FLAGS)
	${INFO} "Delete complete"

environment/%:
	touch inventory
	ansible-playbook -i localhost, environment.yml -e env=$*
	${INFO} "Created environment $*"