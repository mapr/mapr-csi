#!/bin/bash

set -x

# images
REPO_NAME=${REPO_NAME:-maprtech}
EZMERAL_CSI_OPERATOR_IMAGE=${EZMERAL_CSI_OPERATOR_IMAGE:-hpe-ezmeral-csi-operator}
EZMERAL_CSI_OPERATOR_TAG=${EZMERAL_CSI_OPERATOR_TAG:-mapr}

# stage directory for build
IMG_DIR=$(dirname $0)
HELM_DIR=${IMG_DIR}/../../helm/charts
rm -rf ${IMG_DIR}/helm-charts ${IMG_DIR}/LICENSE

mkdir -p ${IMG_DIR}/helm-charts

cp ${IMG_DIR}/../../LICENSE ${IMG_DIR}/

# Copy helm charts to staging directory
cp -r ${HELM_DIR}/hpe-ezmeral-csi-driver ${IMG_DIR}/helm-charts
cp -r ${HELM_DIR}/hpe-ezmeral-nfs-csi-driver ${IMG_DIR}/helm-charts

# build an operator
docker build \
    -t docker.io/${REPO_NAME}/${EZMERAL_CSI_OPERATOR_IMAGE}:${EZMERAL_CSI_OPERATOR_TAG} ${IMG_DIR}


