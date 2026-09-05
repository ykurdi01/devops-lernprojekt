# DevOps Lernprojekt

![CI](https://github.com/ykurdi01/devops-lernprojekt/actions/workflows/ci.yml/badge.svg)

Das ist ein Übungsprojekt aus meinem Studium, mit dem ich mich intensiver mit Docker, Kubernetes und Terraform beschäftige. Es ist bewusst klein genug, um es komplett zu verstehen, aber schon so aufgebaut, wie ich es auch in einem etwas größeren Team-Setting erwarten würde.

## Architektur

Die Anwendung besteht aus zwei Teilen. Eine Flask App übernimmt die eigentliche Logik, Redis dient als gemeinsamer Zustand über mehrere Pods hinweg. Der Endpunkt `/counter` erhöht einen Zähler in Redis, dadurch stimmt der Wert auch dann, wenn mehrere Replicas laufen oder ein Pod neu startet.

Die App unterscheidet außerdem zwischen zwei Arten von Health Checks. `/health` beantwortet nur, ob der Prozess selbst noch läuft, das ist der Liveness Check. `/ready` prüft zusätzlich, ob Redis gerade erreichbar ist, das ist der Readiness Check. Dieser Unterschied ist mir wichtig, weil beide Checks in Kubernetes unterschiedliche Konsequenzen haben. Schlägt Liveness fehl, wird der Pod neu gestartet, schlägt Readiness fehl, wird er nur vorübergehend aus dem Service genommen.

Konfiguration und Geheimnisse sind bewusst getrennt. Unkritische Werte wie die Redis Adresse liegen in einer ConfigMap, der Platzhalter für einen Secret Key liegt in einem Kubernetes Secret. In einem echten Projekt würde ich an dieser Stelle keinen Wert einchecken, sondern etwas wie Sealed Secrets oder den External Secrets Operator einsetzen, das steht auch so im Code als Kommentar.

## Aufbau des Repositories

`app` enthält den Python Code der Flask App sowie die Tests unter `app/tests`.

`docker` enthält ein mehrstufiges Dockerfile, das ein schlankes Image mit einem eigenen, nicht privilegierten Benutzer baut und über gunicorn statt dem Flask Entwicklungsserver läuft.

`kubernetes/base` enthält alle Basis-Manifeste, `kubernetes/overlays/dev` und `kubernetes/overlays/prod` passen darauf mit Kustomize die Replica-Anzahl und die Ressourcenlimits pro Umgebung an, ohne die Basis zu duplizieren.

`terraform/modules` enthält drei wiederverwendbare Module für Namespace, App und Redis. `terraform/environments/dev` und `terraform/environments/prod` setzen diese Module mit eigenen Variablenwerten zusammen, ähnlich wie bei den Kustomize Overlays.

`.github/workflows/ci.yml` baut das Docker Image, führt die Python Tests aus, prüft das Dockerfile mit hadolint, validiert die Terraform Konfiguration für beide Umgebungen und baut probeweise beide Kustomize Overlays.

`docker-compose.yml` und das `Makefile` liegen im Hauptverzeichnis und fassen die wichtigsten Befehle zusammen.

## Lokal ausprobieren

Am schnellsten geht es mit Docker Compose, das startet App und Redis zusammen.

```
make compose-up
```

Danach ist die App unter `http://localhost:5000` erreichbar, zum Beispiel `http://localhost:5000/counter`.

Für die Python Tests reicht ein virtuelles Environment.

```
make install
make test
```

## Mit Kubernetes ausrollen

Für Kubernetes braucht man einen lokalen Cluster, zum Beispiel mit kind oder minikube, sowie kubectl mit eingebauter Kustomize Unterstützung. Das Image muss vorher gebaut und dem Cluster bekannt gemacht werden, bei kind zum Beispiel mit `kind load docker-image`.

```
make docker-build
make k8s-dev
```

Für die prod Variante mit drei Replicas und höheren Ressourcenlimits gibt es entsprechend `make k8s-prod`.

Der HorizontalPodAutoscaler braucht einen laufenden metrics-server im Cluster, der Ingress einen Ingress Controller wie ingress-nginx, die NetworkPolicy ein CNI Plugin mit entsprechender Unterstützung wie Calico. Ohne diese Komponenten werden die jeweiligen Ressourcen zwar angelegt, greifen aber noch nicht vollständig, das ist bei einem lokalen Testcluster normal.

## Mit Terraform ausrollen

Die gleiche Grundstruktur lässt sich auch komplett über Terraform aufbauen, aufgeteilt in Module und Umgebungen.

```
export TF_VAR_app_secret_key="ein-lokaler-testwert"
make tf-dev-plan
```

Für prod gilt dasselbe Prinzip mit `make tf-prod-plan`. Der Secret Key wird bewusst über eine Umgebungsvariable gesetzt und nicht in einer tfvars Datei eingecheckt. Der State liegt aktuell lokal, in `terraform/environments/dev/backend.tf` und `terraform/environments/prod/backend.tf` steht als Kommentar, wie ein Remote Backend mit S3 und DynamoDB Locking aussehen könnte.

## Was noch fehlt und ausgebaut werden könnte

Auch in dieser Version gibt es noch einiges, das ich mir als nächste Schritte vorgenommen habe.

Ein Helm Chart als Alternative zu den Kustomize Overlays, um die Konfiguration auch außerhalb des eigenen Repositories wiederverwendbar zu machen.

Eine echte Cloud Anbindung, zum Beispiel über Terraform ein Kubernetes Cluster bei AWS, Azure oder GCP aufzusetzen statt nur gegen einen lokalen Cluster zu arbeiten.

GitOps mit ArgoCD oder Flux, damit Änderungen an den Manifesten automatisch in den Cluster übernommen werden, statt sie manuell mit kubectl oder Terraform anzuwenden.

Monitoring mit Prometheus und Grafana, um Metriken und das Verhalten der Pods im Betrieb sichtbar zu machen.

Ein automatisiertes Image Publishing in der CI Pipeline, aktuell wird das Image dort nur gebaut und getestet, aber nicht in eine Registry gepusht.

Richtiges Secrets Management mit Sealed Secrets oder Vault, statt des eingecheckten Platzhalterwerts.

## Kurz zu mir

Ich bin Student und beschäftige mich gerade intensiver mit Cloud und Infrastruktur Themen. Dieses Repository soll zeigen, dass ich nicht nur die Grundlagen von Docker, Kubernetes und Terraform kenne, sondern auch schon ein Gefühl dafür entwickelt habe, wie man ein solches Setup strukturiert, testet und für mehrere Umgebungen sauber trennt.
