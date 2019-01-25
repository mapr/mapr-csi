# MapR CSI Storage Plugin

The MapR CSI Storage plugin provides the persistent storage for Application containers. 
For more information, Refer to [MapR documentation](https://mapr.com/docs/home/CSIdriver/csi_plan_and_install.html)

Note: Kubernetes or CSI alpha features are not supported on MapR CSI Storage plugin v1.0.0.

## Pre-requisites

Currently, MapR CSI Storage plugin (v1.0.0) only support Kubernetes as CO (Container Orchestration) system.  

Before installing the MapR Container Storage Interface (CSI) Storage Plugin, Please note the following:  
1. The installation procedure assumes that the Kubernetes cluster is already installed and functioning normally.  
2. The Privileged Pods and Mount Propogation are enabled on the Kubernetes environment. See below procedure to enable them:  
a) Enable privileged Pods  
This can be achieved with starting kubelet and Apiserver with allow-privileged flag to true:  
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
2. kubectl create -f deploy/kubernetes/csi-maprkdf-v1.0.0.yaml  

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

## Installation verification

MapR CSI storage plugin is deployed in `mapr-csi` namespace, by default.  

To verify the installation, following the below procedure:  
1. Verify all the driver components are deployed correctly.  
2. Verify from the kubelet logs on kubernetes worker nodes if MapR CSI Storage plugin driver `com.mapr.csi-kdf` is
registered with kubelet successfullly.  
3. Run the Sample examples from [Sample]([#how-to-use) and verify the MapR CSI storage plugin is working as expected.  


## How to use

MapR CSI Storage plugin support Static and Dynamic volume provisioning for Containers. See the following to use it in 
kubernetes environment.

### Static Volume Provisioning

Run the following examples from the `examples` directory for static provisioning.

```
$ cd examples
```

1) Create Test namespace to run example yamls

```
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret

   Note: This step is only required when using static provisioning with MapR Secure Cluster.

```
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create PVC

```
$ kubectl create -f teststaticpvc.yaml
```

4) Create PV

```
$ kubectl create -f teststaticpv.yaml
```

5) Verify that PV and PVC are bound to each other at this point.

```
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV and PVC are not bounded or still in waiting status, Run the following command to debug:

```
$ kubectl describe pvc <pvc-name> -n test-csi
$ kubect describe pv <pv-name> -n test-csi 
```
6) Create Pod using above PVC

```
kubectl create -f teststaticpod.yaml
```

7) Verify that the Pod created in step(5) has the requested volume mount for MapR cluster volume.

```
kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Dynamic Volume Provisioning

Run the following examples from the `examples` directory for dynamic provisioning.

```
$ cd examples
```

1) Create Test namespace to run example yamls

```
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret
   
   Note: This step is only required when using static provisioning with MapR Secure Cluster.

```
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create Rest secret for dynamic volume provisioning

```
$ kubectl create -f testsecurerestsecret.yaml
```

4) Create Storage Class using MapR CSI storage plugin driver

```
$ kubectl create -f teststorageclass.yaml
```

5) Create PVC

```
$ kubectl create -f testdynamicpvc.yaml
```

The above command will provide `volumehandle` which is the MapR Volume being provisioned.

6) Verify that PV is created and PV/PVC are bounded.

```
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV is not created, see the provisioner log from provisioner deployed worker node for more info:

```
$ cat /var/log/csi-maprkdf/csi-provisioner-1.0.0.log
```

7) Create Pod using above PVC

```
kubectl create -f testdynamicpod.yaml
```

8) Verify that the Pod created in step(5) has the requested volume mount for MapR cluster volume.

```
kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Snapshotting

With MapR CSI Storage Plugin v1.0.0, Snapshot provisioning is supported for dynamically provisioned volumes only. This provides
 support for creating/deleting MapR snapshot for newly provisioned volumes created with MapR CSI provisioner.
 
Run the following examples from the `examples` directory for Snapshot.

```
$ cd examples
```

1) Create Test namespace to run example yamls

```
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret
      
   Note: This step is only required when using static provisioning with MapR Secure Cluster.

```
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create Rest-secret for MapR provisioner

```
$ kubectl create -f testprovisionerrestsecret.yaml
```

4) If not created already, Create StorageClass using MapR CSI storage plugin driver

```
$ kubectl create -f testdynamicSC.yaml
```

5) If not created already, Create PersistentVolumeClaim (PVC)

```
$ kubectl create -f testdynamicpvc.yaml
```

6) Verify that PersistentVolume (PV) is created and PV/PVC are bounded.

```
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV is not created, see the provisioner log from provisioner deployed worker node for more info:

```
$ cat /var/log/csi-maprkdf/csi-provisioner-1.0.0.log
```

7) Create Volume SnapshotClass for snapshot

```
$ kubectl create -f testvolumesnapshotclass.yaml
```

8) Create Volume Snapshot

```
$ kubectl create -f testvolumesnapshot.yaml
```

9) Verify that the snapshot is provisioned on MapR cluster

```
$ kubectl get crd
$ kubectl describe volumesnapshotclasses.snapshot.storage.k8s.io -n test-csi
$ kubectl describe volumesnapshots.snapshot.storage.k8s.io -n test-csi
$ kubectl describe volumesnapshotcontents.snapshot.storage.k8s.io -n test-csi
```

The above command will provide `snapshothandle` which is the MapR snapshot being provisioned for given PVC 
 referenced in the Volume Snapshot.
 
 
## Uninstall

To remove MapR CSI storage plugin from Kubernetes cluster, Run the following:

```
$ kubectl delete -f deploy/kubernetes/csi-maprkdf-v1.0.0.yaml
```

## Note: For any suggestion, issues or improvements, Please file a github issue.