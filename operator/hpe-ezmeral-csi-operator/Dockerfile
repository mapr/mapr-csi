FROM quay.io/operator-framework/helm-operator:v1.42

LABEL name="HPE Ezmeral CSI Operator" \
      maintainer="HPE Ezmeral Data Fabric" \
      vendor="HPE" \
      version="1.0.19" \
      release="1.0" \
      summary="HPE Ezmeral CSI Operator" \
      description="HPE Ezmeral Data Fabric CSI Operator for Kubernetes" \
      io.k8s.display-name="HPE Ezmeral Data Fabric CSI Operator for Kubernetes" \
      io.k8s.description="The HPE Ezmeral Data Fabric CSI Operator for Kubernetes enables container orchestrators, such as Kubernetes and OpenShift, to manage the life-cycle of persistent storage." \
      io.openshift.tags=hpe,hpe-ezmeral,csi,hpe-ezmeral-csi-driver

COPY LICENSE /licenses/

ENV HOME=/opt/helm
COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts  ${HOME}/helm-charts
WORKDIR ${HOME}
