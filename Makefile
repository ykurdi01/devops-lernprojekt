.PHONY: help install test run compose-up compose-down docker-build k8s-dev k8s-prod tf-dev-plan tf-prod-plan fmt

help:
	@echo "Verfuegbare Befehle: install, test, run, compose-up, compose-down, docker-build, k8s-dev, k8s-prod, tf-dev-plan, tf-prod-plan, fmt"

install:
	pip install -r app/requirements.txt -r app/requirements-dev.txt

test:
	pytest app/tests

run:
	python app/app.py

compose-up:
	docker compose up --build

compose-down:
	docker compose down -v

docker-build:
	docker build -t lernprojekt-app:0.2.0 -f docker/Dockerfile .

k8s-dev:
	kubectl apply -k kubernetes/overlays/dev

k8s-prod:
	kubectl apply -k kubernetes/overlays/prod

tf-dev-plan:
	cd terraform/environments/dev && terraform init && terraform plan

tf-prod-plan:
	cd terraform/environments/prod && terraform init && terraform plan

fmt:
	terraform fmt -recursive terraform
