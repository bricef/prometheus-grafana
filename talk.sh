## Prequisites
# 
# - Have VitualBox (or another VM driver) installed
# - Have kubctl installed 
#   (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
#
#       > brew install kubectl
#


#  1. Install minikube
#     (https://github.com/kubernetes/minikube/releases)
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.1/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

#  2. Start the minikube cluster
#     Note this will set up kubctl to speak with your minikube install
minikube start

#  3. Create a prometheus deployment 
kubectl apply -f config/kubernetes/deployment-prometheus.yaml 

#  4. Create a prometheus external service
kubectl apply -f config/kubernetes/service-prometheus.yaml

#  5. Create a prometheus internal service
kubectl apply -f config/kubernetes/service-internal-prom.yaml

#  6. create a Grafana deployment
kubectl apply -f config/kubernetes/deployment-grafana.yaml

#  7. Create a Grafana external service
kubectl apply -f config/kubernetes/service-grafana.yaml

#  8. Create a new configuration for prometheus
kubectl create configmap prometheus-config --from-file=prometheus.yml=config/prometheus/prometheus.yml --dry-run -o yaml | kubectl apply -f -

#  9. Mount the new configmap to the deployment's pod
cat >> config/kubernetes/deployment-prometheus.yaml
        volumeMounts:
        - name: prometheus-config
          mountPath: /etc/prometheus/
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-configmap

#  10. Re-apply the config to the deployment
kubectl apply -f config/kubernetes/deployment-prometheus.yaml



# 11. Deploy the sock shop
kubectl apply -f https://github.com/microservices-demo/microservices-demo/raw/master/deploy/kubernetes/complete-demo.yaml


