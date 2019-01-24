# MapR CSI Storage Plugin

The MapR CSI Storage plugin provides the persistent storage for Application containers. 
For more information, refere [MapR documentation](https://mapr.com/docs/home/CSIdriver/csi_plan_and_install.html)

Note: Kubernetes or CSI alpha features are not supported on MapR CSI Storage plugin v1.0.0.

## Pre-requisites

Currently, MapR CSI Storage plugin (v1.0.0) only support Kubernetes as CO (Container Orchestration) system.  

Before installing the MapR Container Storage Interface (CSI) Storage Plugin, Please note the following:  
1. The installation procedure assumes that the Kubernetes cluster is already installed and functioning normally.  
2. The Privileged Pods and Mount Propogation are enabled on the Kubernetes environment. See below procedure to enable them:  
a) Enable privileged Pods  
This can be achieved with starting kubelet and Apiserver with privileged flag:  
`./kube-apiserver ...  --allow-privileged=true ...`  
`./kubelet ...  --allow-privileged=true ...`

*Note*: This is default in some environments, such as GKE, Kubeadm etc.  

b) Enable mount propogation  
MapR CSI Storage plugin require the mount propogation enabled on the Kubernetes environment. This will
allow sharing of volumes mounted by one container with other containers in the same pod, or even
to other pods on the same node.  
See [Mount Propogation](https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation)
for more info.

## Installation

Follow the below procedure to install MapR CSI Storage plugin in Kubernetes environment:   
1. clone the repository (https://github.com/mapr/mapr-csi.git)  
2. cd build  
3. kubectl create -f csi-maprkdf-v1.0.0.yaml  

*Note*: csi-maprkdf-v1.0.0.yaml provides the MapR released CSI storage plugin based off Centos OS image and CSI KDF driver.  
If you would like to build your own container with other supported Posix Client OS, Please refer to 
[BYOC for MapR CSI Storage Plugin](#optional-build-your-own-container-for-mapr-csi-storage-plugin)

## (Optional) Build your own container for MapR CSI Storage plugin

This step and optional and only require if user would like to build a custom plugin with the given template.  
The sample template is provided as a reference to build a custom plugin image:  
a) cd build/<centos/ubuntu>
b) (Optional) Modify the `maprtech/csi-kdfdriver` tag to an updated tag in `Dockerfile`
c) (Optional) Modify the docker image tag for custom docker image name in `docker-custom-build.sh`
d) Run `./docker-custom-build.sh` to start building the docker image

## installation verification

MapR CSI storage plugin is deployed in `mapr-csi` namespace, by default.  

To verify the installation, following the below procedure:  
1. Verify all the driver components are deployed correctly.  
2. Verify from the kubelet logs on kubernetes worker nodes if MapR CSI Storage plugin driver `com.mapr.csi-kdf` is
registered with kubelet successfullly.  
3. Run the Sample examples from (Sample)[#how-to-use] and verify the MapR CSI storage plugin is working as expected.  


## How to use

MapR CSI Storage plugin support Static and Dynamic provisioning for Containers. See the following to use it in 
kubernetes environment

### Static Provisioning

Run the following examples from the `examples` directory for static provisioning.

```
$ cd examples
```

1) (Optional) Create Cluster ticket secret

This is an optional step, and only require static provisioning with Secure MapR cluster.

```
$ kubectl create -f testsecureticketsecret.yaml
```

2) Create PVC

```
$ kubectl create -f teststaticpvc.yaml
```

3) Create PV

```
$ kubectl create -f teststaticpv.yaml
```

4) Verify that PV and PVC are bound to each other at this point.

```
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV and PVC are not bounded or still in waiting status, Run the following command to debug:

```
$ kubectl describe pvc <pvc-name> -n test-csi
$ kubect describe pv <pv-name> -n test-csi 
```
5) Create Pod using above PVC

```
kubectl create -f teststaticpod.yaml
```

6) Verify that the Pod created in step(5) has the requested volume mount for MapR cluster volume.

```
kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Dynamic Provisioning

Run the following examples from the `examples` directory for dynamic provisioning.

```
$ cd examples
```

1) (Optional) Create Cluster ticket secret

This is an optional step, and only require static provisioning with Secure MapR cluster.

```
$ kubectl create -f testsecureticketsecret.yaml
```

2) Create Rest secret for dynamic volume provisioning

```
$ kubectl create -f testsecurerestsecret.yaml
```

3) Create Storage Class using MapR CSI storage plugin driver

```
$ kubectl create -f testdynamicSC.yaml
```

4) Create PVC

```
$ kubectl create -f testdynamicpvc.yaml
```

4) Verify that PV is created and PV/PVC are bounded.

```
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV is not created, see the provisioner log from provisioner deployed worker node for more info:

```
$ cat /var/log/csi-maprkdf/csi-provisioner-1.0.0.log
```

5) Create Pod using above PVC

```
kubectl create -f testdynamicpod.yaml
```

6) Verify that the Pod created in step(5) has the requested volume mount for MapR cluster volume.

```
kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```