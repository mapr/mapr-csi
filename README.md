# MapR CSI Storage Plugin

<img src="https://mapr.com/solutions/data-fabric/kubernetes/assets/kubernetes-diagram.png" width="800" height="400" />

The MapR CSI Storage plugin provides the persistent storage for Application containers. 
For more information, Refer to [MapR documentation](https://mapr.com/docs/home/CSIdriver/csi_plan_and_install.html)

Note: Kubernetes or CSI alpha features are not supported on MapR CSI Storage plugin v1.0.0.

## MapR CSI Storage Plugin Support Matrix

<table>
  <thead>
    <tr>
      <th>MapR CSI Plugin version</th>
      <th>Supported Kubernetes Version</th>
      <th>CSI Spec version</th>
      <th>Posix Client (Core) Version</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>v1.0.0</td>
      <td>>=1.13.0</td>
      <td><a href="https://github.com/container-storage-interface/spec/blob/v1.0.0/spec.md">v1.0.0</a></td>
      <td>6.1.0</td>
    </tr>
  </tbody>
</table>

The released MapR CSI Storage plugin docker images will be published to:  
[maprtech/csi-kdfplugin](https://hub.docker.com/r/maprtech/csi-kdfplugin)  
[maprtech/csi-kdfprovisioner](https://hub.docker.com/r/maprtech/csi-kdfprovisioner)  
[maprtech/csi-kdfdriver](https://hub.docker.com/r/maprtech/csi-kdfdriver)  

## Pre-requisites

Currently, MapR CSI Storage plugin (v1.0.0) only support Kubernetes as CO (Container Orchestration) system.  

Before installing the MapR Container Storage Interface (CSI) Storage Plugin, Please note the following:  
1. The installation procedure assumes that the Kubernetes cluster (See supported Kubernetes version) is already installed and functioning normally.  
2. Configure `--maxvolumepernode` to Maximum volumes allowed on a node as per it's capacity in the `deploy/kubernetes/csi-maprkdf-v1.0.0.yaml` accordingly.  
3. The Privileged Pods and Mount Propogation are enabled on the Kubernetes environment. See below procedure to enable them:  
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

*Note*: To test if Mount Propagation is enabled, Run the following command and it should run fine without error.

```bash
$ docker run -it -v /mnt:/mnt:shared busybox sh -c ls /
```

Note: For more detail instructions, Please refer to [Public CSI Documentation](https://kubernetes-csi.github.io/docs/Setup.html)  

## Installation

Follow the below procedure to install MapR CSI Storage plugin in Kubernetes environment:  
 
*Note*: The following steps requires the `git` and `kubectl` to be installed on the computer.  

1. clone the mapr-csi repository
```bash
$ git clone https://github.com/mapr/mapr-csi.git
```
2. cd to mapr-csi directory
```bash
$ cd mapr-csi
```
3. Deploy Installation yaml file for MapR CSI storage 
```bash
$ kubectl create -f deploy/kubernetes/csi-maprkdf-v1.0.2.yaml
```

*Note*: `csi-maprkdf-v1.0.2.yaml` provides the MapR released CSI storage plugin based of MapR provided Centos OS image and CSI KDF driver.  
If you would like to build your own container with other supported Posix Client OS and modify the image in `csi-maprkdf-v1.0.2.yaml`, Please refer to 
[BYOC for MapR CSI Storage Plugin](#optional-build-your-own-container-for-mapr-csi-storage-plugin) for more info.

## (Optional) Build your own container for MapR CSI Storage plugin

This step is optional and is provided as a reference to build a custom plugin image:  

*Note*: This step requires `docker` to be installed on the computer.

a) cd build/<centos/ubuntu>  
b) (Optional) Modify the `maprtech/csi-kdfdriver` tag to an released tag in `Dockerfile`  
c) (Optional) Modify the custom image tag in `docker-custom-build.sh`  
d) Run `./docker-custom-build.sh` to start building the custom docker image  

## Installation verification

MapR CSI storage plugin is deployed in `mapr-csi` namespace, by default.  

To verify the installation, following the below procedure:  
1. Verify all the driver components are deployed correctly and is in RUNNING state.  
```bash
$ kubectl get pods -n mapr-csi
```
2. Verify from the kubernetes worker nodes if log files are generated correctly and plugin/provisioner is initialized and registered.

a) The following should be generated on each Kubernetes worker nodes where the plugin daemonset pod is scheduled to run. 
```bash
$ cat /var/log/csi-maprkdf/csi-plugin-1.0.0.log
```

b) The following should be generated where the provisioner stateful pod is running.
```
$ cat /var/log/csi-maprkdf/csi-provisioner-1.0.0.log
 ```
3. Run the Sample examples from [Sample]([#how-to-use) and verify the MapR CSI storage plugin and provisioner is working as expected.  


## How to use

MapR CSI Storage plugin support Static and Dynamic volume provisioning for Containers. See the following to use it in 
kubernetes environment.

### Static Volume Provisioning

Run the following examples from the `examples` directory for static provisioning.

```bash
$ cd examples
```

1) Create Test namespace to run example yamls

```bash
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret

   Note: This step is only required when using static provisioning with MapR Secure Cluster.

```bash
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create PVC

```bash
$ kubectl create -f teststaticpvc.yaml
```

4) Create PV

```bash
$ kubectl create -f teststaticpv.yaml
```

5) Verify that PV and PVC are bound to each other at this point.

```bash
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV and PVC are not bounded or still in waiting status, Run the following command to debug:

```bash
$ kubectl describe pvc <pvc-name> -n test-csi
$ kubect describe pv <pv-name> -n test-csi 
```
6) Create Pod using above PVC

```bash
kubectl create -f teststaticpod.yaml
```

7) Verify that the Pod created in step(5) has the requested volume mount for MapR cluster volume.

```bash
kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Dynamic Volume Provisioning

Run the following examples from the `examples` directory for dynamic provisioning.

```bash
$ cd examples
```

1) Create Test namespace to run example yamls

```bash
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret
   
   Note: This step is only required when using static provisioning with MapR Secure Cluster.

```bash
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create Rest secret for dynamic volume provisioning

```bash
$ kubectl create -f testprovisionerrestsecret.yaml
```

4) Create Storage Class using MapR CSI storage plugin driver

```bash
$ kubectl create -f testsecurestorageclass.yaml
```

5) Create PVC

```bash
$ kubectl create -f testdynamicpvc.yaml
```

The above command will provide `volumehandle` which is the MapR Volume being provisioned.

6) Verify that PV is created and PV/PVC are bounded.

```bash
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV is not created, see the provisioner log from provisioner deployed worker node for more info:

```bash
$ cat /var/log/csi-maprkdf/csi-provisioner-1.0.0.log
```

7) Create Pod using above PVC

```bash
$ kubectl create -f testdynamicpod.yaml
```

8) Verify that the Pod created in step(5) has the requested volume mount for MapR cluster volume.

```bash
$ kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Snapshotting

With MapR CSI Storage Plugin v1.0.2, Snapshot provisioning is supported for dynamically provisioned volumes only. This provides
 support for creating/deleting MapR snapshot for newly provisioned volumes created with MapR CSI provisioner.
 
Run the following examples from the `examples` directory for Snapshot.

```bash
$ cd examples
```

1) Create Test namespace to run example yamls

```bash
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret
      
   Note: This step is only required when using static provisioning with MapR Secure Cluster.

```bash
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create Rest-secret for MapR provisioner

```bash
$ kubectl create -f testprovisionerrestsecret.yaml
```

4) If not created already, Create StorageClass using MapR CSI storage plugin driver

```bash
$ kubectl create -f testdynamicSC.yaml
```

5) If not created already, Create PersistentVolumeClaim (PVC)

```bash
$ kubectl create -f testdynamicpvc.yaml
```

6) Verify that PersistentVolume (PV) is created and PV/PVC are bounded.

```bash
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV is not created, see the provisioner log from provisioner deployed worker node for more info:

```bash
$ cat /var/log/csi-maprkdf/csi-provisioner-1.0.0.log
```

7) Create Volume SnapshotClass for snapshot

```bash
$ kubectl create -f testvolumesnapshotclass.yaml
```

8) Create Volume Snapshot

```bash
$ kubectl create -f testvolumesnapshot.yaml
```

9) Verify that the snapshot is provisioned on MapR cluster

```bash
$ kubectl get crd
$ kubectl describe volumesnapshotclasses.snapshot.storage.k8s.io -n test-csi
$ kubectl describe volumesnapshots.snapshot.storage.k8s.io -n test-csi
$ kubectl describe volumesnapshotcontents.snapshot.storage.k8s.io -n test-csi
```

The above command will provide `snapshothandle` which is the MapR snapshot being provisioned for given PVC 
 referenced in the Volume Snapshot.
 
 
## Uninstall

To remove MapR CSI storage plugin from Kubernetes cluster, Run the following:

```bash
$ kubectl delete -f deploy/kubernetes/csi-maprkdf-v1.0.2.yaml
```

## Note: For any suggestion, issues or improvements, Please file a github issue.