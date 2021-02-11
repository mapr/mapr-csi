## Troubleshooting

The following describe the possible causes and fix for any of the following issues:

### Installation

HPE Ezmeral Data Fabric CSI storage plugin is deployed in `mapr-csi` namespace, by default.  

To verify the installation, following the below procedure:  
1. Verify all the driver components are deployed correctly and is in RUNNING state.  
```bash
$ kubectl get pods -n mapr-csi
```   
2. Verify from the kubernetes worker nodes if plugin and provisioner log files are generated and initialized/registered.

a) The following should be generated on each Kubernetes worker nodes where the plugin daemonset pod is scheduled to run.  
```bash
$ cat /var/log/csi-maprkdf/csi-plugin-<version>.log
```

b) The following should be generated where the provisioner stateful pod is running.  
```bash
$ cat /var/log/csi-maprkdf/csi-provisioner-<version>.log
 ```
 
### Usage


#### Troubleshooting mount operation

See the CSI Storage plug-in log and check for any mount/unmount errors:  
```bash
$ tail -100f /var/log/csi-maprkdf/csi-plugin-<version>.log
```  
Note: Check the above on the Kubernetes worker node where the application pod (using CSI) is scheduled to run.  

#### Troubleshooting HPE Ezmeral Data Fabric CSI Storage Plugin discovery with kubelet

Verify the kubelet path for kubernetes with --root-dir. The --root-dir contains the directory path for managing kubelet files (such as volume mounts, etc.,) and defaults to /var/lib/kubelet.  
If the kubernetes environment has a different kubelet path, modify the [deployment yaml](../deploy/kubernetes/csi-maprkdf-v1.2.0.yaml) with new path and redeploy the HPE Ezmeral Data Fabric CSI Storage Plugin.

#### Troubleshooting a volume provisioning

See the provisioner log and check for any provisioner errors:  
```bash
$ tail -100f /var/log/csi-maprkdf/csi-provisioner-<version>.log
```

#### Troubleshooting provisioned volume

To get the HPE Ezmeral Data Fabric volume with mount-path provisioned, run the following and see the `VolumeHandle` and `volumePath`.  
```bash
$ kubectl describe pv <dynamically-provisioned-pv-name> -n <namespace>
```

Note: To get the dynamically-provisioned-pv-name, Run the following and see the `Volume`  
```bash
$ kubectl describe pvc <pvc-name> -n <namespace>
```