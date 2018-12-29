#!/bin/sh


set -x


SCRIPT_ROOT=$(dirname "$0")
cd ${SCRIPT_ROOT}
. ../sbin/env.sh
cd -


installDependencies() {
    apk add -U openssl curl tar gzip bash ca-certificates git
    curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
    curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
    apk add glibc-2.28-r0.apk
    rm glibc-2.28-r0.apk

    curl "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar zx
    mv linux-amd64/helm /usr/bin/
    mv linux-amd64/tiller /usr/bin/
    helm version --client
    tiller -version

    curl -L -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl"
    chmod +x /usr/bin/kubectl
    kubectl version --client
}

#AutoChartName=auto-deploy-app.tar.gz
#AutoChartName=${AutoChartName%.tar.gz}
# --> auto-deploy-app
downloadChart() {
    AutoChart=gitlab/auto-deploy-app
    AutoChartName=$(basename ${AutoChart})

    helm init --client-only
    helm repo add gitlab https://charts.gitlab.io
    helm fetch ${AutoChart} --untar
    mv ${AutoChartName} chart

    helm dependency update chart/
    helm dependency build chart/

    mv chart /
}

run() {
    installDependencies
    downloadChart
}


HELM_VERSION=2.12.1
KUBERNETES_VERSION=1.13.0

run

set +x
