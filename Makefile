# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test -count=1
GOGET=$(GOCMD) get
GO111MODULE=on
GOOS?=darwin
GOARCH=amd64
GITHUB_USER=davidmontoyago

cluster:
	kind create cluster --name flux-cluster

flux:
	kubectl create ns flux
	
	fluxctl install \
	--git-user=${GITHUB_USER} \
	--git-email=${GITHUB_USER}@users.noreply.github.com \
	--git-url=git@github.com:${GITHUB_USER}/flux-get-started \
	--git-path=namespaces,workloads \
	--namespace=flux | kubectl apply -f -
	
	kubectl -n flux rollout status deployment/flux

list-work:
	fluxctl list-workloads --k8s-fwd-ns flux