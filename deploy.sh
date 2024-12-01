kubectl apply -f rstudio-on-jh/configmap.yaml
kubectl create secret generic secret-naavre-rstudio --from-literal=NAAVRE_API_TOKEN=${NAAVRE_API_TOKEN}
helm upgrade --install --cleanup-on-fail jh-rstudio jupyterhub/jupyterhub --version=3.2.1 --values rstudio-on-jh/helm/config.yaml
helm upgrade --install paas oci://ghcr.io/qcdis/charts/vrepaas -f vreapi/helm/config.yaml
