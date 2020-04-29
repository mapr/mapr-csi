# MapR CSI Storage Plugin

<img src="https://mapr.com/solutions/data-fabric/kubernetes/assets/kubernetes-diagram.png" width="800" height="400" />

The MapR CSI Storage plugin provides the persistent storage for Application containers. 
For more information, Refer to [MapR documentation](https://mapr.com/docs/home/CSIdriver/csi_plan_and_install.html)

Note: Kubernetes or CSI alpha features are not supported on MapR CSI Storage plugin v1.0.2.

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
      <td>v1.0.2</td>
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

Currently, MapR CSI Storage plugin (v1.0.2) only support Kubernetes as CO (Container Orchestration) system.  

Before installing the MapR Container Storage Interface (CSI) Storage Plugin, Please note the following:  
1. The installation procedure assumes that the Kubernetes cluster (See supported Kubernetes version) is already installed and functioning normally.  
2. Configure `--maxvolumepernode` to Maximum volumes allowed on a node as per it's capacity in the `deploy/kubernetes/csi-maprkdf-v1.0.2.yaml` accordingly.  
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

### Please refer to [Troubleshooting](examples/troubleshooting.md) section for the installation troubleshooting tips.

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

## Check out the [sample examples](examples/how-to-use.md) section for the usage of MapR CSI storage plugin.  

## Uninstall

To remove MapR CSI storage plugin from Kubernetes cluster, Run the following:

```bash
$ kubectl delete -f deploy/kubernetes/csi-maprkdf-v1.0.2.yaml
```

## Note: For any suggestion, issues or improvements, Please file a github issue.