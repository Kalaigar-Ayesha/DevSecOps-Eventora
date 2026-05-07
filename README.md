# Eventora MERN Application

## Monitoring and Observability (PLG Stack)

The application has been instrumented to expose Prometheus metrics and ship logs to Loki. The infrastructure is deployed via Helm.

### Installation

1. Add the required Helm repositories:
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo add grafana https://grafana.github.io/helm-charts
   helm repo update
   ```

2. Create the monitoring namespace:
   ```bash
   kubectl create namespace monitoring
   ```

3. Deploy the kube-prometheus-stack (Prometheus, Grafana, Alertmanager):
   ```bash
   helm install prometheus prometheus-community/kube-prometheus-stack \
     -n monitoring \
     -f k8s/monitoring/prometheus-values.yaml
   ```

4. Deploy the loki-stack (Loki, Promtail):
   ```bash
   helm install loki grafana/loki-stack \
     -n monitoring \
     -f k8s/monitoring/loki-values.yaml
   ```

5. Apply the custom Grafana Dashboard:
   ```bash
   kubectl apply -f k8s/monitoring/grafana-dashboard-configmap.yaml
   ```

### Accessing Grafana

Port-forward Grafana to your local machine:
```bash
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
```
Then visit `http://localhost:3000` (Default credentials: `admin` / `admin`). Your custom MERN dashboard should be pre-loaded under Dashboards.
