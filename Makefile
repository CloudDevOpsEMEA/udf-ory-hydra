# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

HYDRA_NAMESPACE=hydra
HYDRA_NAMESPACE_SPEC=./kubernetes/namespace.yaml

HELM_HYDRA=./helm/charts/hydra
HELM_HYDRA_CONSENT_APP=./helm/charts/hydra-consent-app

HYDRA_LOCAL_VALUES=./helm/values-hydra-udf.yaml
HYDRA_CONSENT_APP_LOCAL_VALUES=./helm/values-hydra-consent-app-udf.yaml


##### Hydra ######
helm_install_hydra: ## Install hydra
	kubectl apply -f ${HYDRA_NAMESPACE_SPEC}
	helm install hydra-consent-app ${HELM_HYDRA_CONSENT_APP} --namespace ${HYDRA_NAMESPACE} --values ${HYDRA_CONSENT_APP_LOCAL_VALUES}
	helm install hydra ${HELM_HYDRA} --namespace ${HYDRA_NAMESPACE} --values ${HYDRA_LOCAL_VALUES}

helm_upgrade_hydra: ## Upgrade hydra
	helm upgrade hydra-consent-app ${HELM_HYDRA_CONSENT_APP} --namespace ${HYDRA_NAMESPACE} --values ${HYDRA_CONSENT_APP_LOCAL_VALUES}
	helm upgrade hydra ${HELM_HYDRA} --namespace ${HYDRA_NAMESPACE} --values ${HYDRA_LOCAL_VALUES}

helm_remove_hydra: ## Remove hydra
	helm uninstall hydra-consent-app --namespace ${HYDRA_NAMESPACE}
	helm uninstall hydra --namespace ${HYDRA_NAMESPACE}
	kubectl delete -f ${HYDRA_NAMESPACE_SPEC}
