# DevOps Lernprojekt

Das ist ein kleines Übungsprojekt aus meinem Studium, mit dem ich die Grundlagen von Docker, Kubernetes und Terraform ausprobiere und zeige, wie diese drei Werkzeuge zusammenspielen.

Im Kern steckt eine sehr einfache Flask App. Sie gibt auf der Startseite eine kurze Nachricht sowie den Namen des Pods zurück, in dem sie gerade läuft, und hat zusätzlich einen `/health` Endpunkt für Health Checks.

## Was ich damit üben wollte

Ich wollte einmal den kompletten Weg von Code bis in einen laufenden Kubernetes Cluster nachvollziehen, ohne dass es gleich zu komplex wird. Deshalb ist der Umfang bewusst klein gehalten.

Mit Docker wird die App in ein Image gepackt. Mit Kubernetes wird dieses Image dann als Deployment mit zwei Replicas sowie als Service ausgerollt. Mit Terraform lässt sich genau dieselbe Kubernetes Infrastruktur alternativ auch als Code beschreiben und verwalten, statt die YAML Dateien manuell mit kubectl anzuwenden.

## Aufbau des Repositories

`app` enthält den Python Code der Flask App.

`docker` enthält das Dockerfile für das Image.

`kubernetes` enthält die YAML Manifeste für Namespace, Deployment und Service.

`terraform` enthält dieselben Ressourcen noch einmal als Terraform Code, mit dem hashicorp/kubernetes Provider.

`docker-compose.yml` liegt im Hauptverzeichnis und dient nur dazu, die App schnell lokal zu testen, ganz ohne Kubernetes.

## Lokal ausprobieren

Für einen schnellen Test reicht Docker Compose.

```
docker compose up --build
```

Danach ist die App unter `http://localhost:5000` erreichbar.

## Mit Kubernetes ausrollen

Für Kubernetes braucht man einen lokalen Cluster, zum Beispiel mit kind oder minikube. Das Image muss vorher gebaut und dem Cluster bekannt gemacht werden, bei kind zum Beispiel mit `kind load docker-image`.

```
docker build -t lernprojekt-app:0.1.0 -f docker/Dockerfile .
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
```

## Mit Terraform ausrollen

Alternativ lässt sich derselbe Zustand auch über Terraform erzeugen.

```
cd terraform
terraform init
terraform plan
terraform apply
```

## Was noch fehlt und ausgebaut werden könnte

Das Projekt ist noch recht überschaubar, das ist bei einem Lernprojekt aus meiner Sicht auch völlig in Ordnung. Ein paar Ideen, wie ich es später erweitern möchte.

Eine kleine CI Pipeline, die das Image automatisch baut und testet.

Ein Helm Chart statt der einzelnen YAML Dateien, um die Konfiguration flexibler zu machen.

Eine echte Cloud Anbindung, zum Beispiel über Terraform ein Kubernetes Cluster bei AWS, Azure oder GCP aufzusetzen statt nur lokal zu arbeiten.

Ein Ingress statt NodePort, um die App sauberer nach außen zu öffnen.

Monitoring mit Prometheus und Grafana, um zu sehen, wie sich die Pods im Betrieb verhalten.

Automatisches Skalieren der Replicas je nach Auslastung mit einem Horizontal Pod Autoscaler.

## Kurz zu mir

Ich bin Student und beschäftige mich gerade mit den Grundlagen von Cloud und Infrastruktur. Dieses Repository soll vor allem zeigen, dass ich die Basics von Docker, Kubernetes und Terraform verstanden habe und weiß, wie man damit sinnvoll startet.
