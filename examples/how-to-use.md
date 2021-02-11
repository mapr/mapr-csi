## How to use

HPE Ezmeral Data Fabric CSI Storage plugin supports Static and Dynamic volume provisioning for Containers. See the following to use it in 
kubernetes environment.

Note: Sensitive data contained in a Secret (*secret.yaml) must be represented in base64 encoded value.  
For example, the following convert a string to a base64 value:  
```bash
$ echo -n 'mapr' | base64
```  
The output shows the base64 representation of the string mapr is `bWFwcg==`

      
### Static Volume Provisioning

The following video demonstrates the procedure for static provisioning in a single-node Kubernetes cluster and the HPE Ezmeral Data Fabric sandbox:

<a href="https://asciinema.org/a/rPc7SQswjJPB5DuPJnQ8K4Zi8" target="_blank"><img src="https://asciinema.org/a/rPc7SQswjJPB5DuPJnQ8K4Zi8.svg" width="400"/></a>

Run the following examples from the `examples` directory for static provisioning.

```bash
$ cd examples
```

1) Create Test namespace to run example yamls

```bash
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret

   Note: This step is only required when using static provisioning with HPE Ezmeral Data Fabric Secure Cluster.

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

7) Verify that the Pod created in step(5) has the requested volume mount for HPE Ezmeral Data Fabric cluster volume.

```bash
kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Dynamic Volume Provisioning

The following video demonstrates the procedure for dynamic provisioning in a single-node Kubernetes cluster and the HPE Ezmeral Data Fabric sandbox:

<a href="https://asciinema.org/a/225777" target="_blank"><img src="https://asciinema.org/a/225777.svg" width="400"/></a>

Run the following examples from the `examples` directory for dynamic provisioning.

```bash
$ cd examples
```

1) Create Test namespace to run example yamls

```bash
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret
   
   Note: This step is only required when using static provisioning with HPE Ezmeral Data Fabric Secure Cluster.

```bash
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create Rest secret for dynamic volume provisioning

```bash
$ kubectl create -f testprovisionerrestsecret.yaml
```

4) Create Storage Class using HPE Ezmeral Data Fabric CSI storage plugin driver

```bash
$ kubectl create -f testsecurestorageclass.yaml
```

5) Create PVC

```bash
$ kubectl create -f testdynamicpvc.yaml
```

The above command will provide `volumehandle` which is the HPE Ezmeral Data Fabric Volume being provisioned.

6) Verify that PV is created and PV/PVC are bounded.

```bash
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

Note: If PV is not created, see the provisioner log from provisioner deployed worker node for more info:

```bash
$ cat /var/log/csi-maprkdf/csi-provisioner-<version>.log
```

7) Create Pod using above PVC

```bash
$ kubectl create -f testdynamicpod.yaml
```

8) Verify that the Pod created in step(5) has the requested volume mount for HPE Ezmeral Data Fabric cluster volume.

```bash
$ kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Volume Clone

Volume clone is supported for dynamically provisioned volumes. This provides support for creating a new 
 HPE Ezmeral Data Fabric volume from a volume previously created with HPE Ezmeral Data Fabric CSI provisioner.

Run the following example from the `examples` directory to clone the volume created in the Dynamic Volume Provisioning section.

```bash
$ cd examples
```

1) Create a PVC (clone of previously created PVC) & create a Pod to use this PVC

```bash
$ kubectl apply -f testvolumeclone.yaml
```

2) Verify that the PVC & Pod are created and the requested volume mount has data from the source volume

```bash
$ kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Volume Expansion

Volume expansion is supported for dynamically provisioned volumes only. This provides support for increasing the storage quota of newly provisioned volumes created with HPE Ezmeral Data Fabric CSI provisioner.

Steps are same as followed for Dynamic Volume Provisioning above with the addition of reapplying testdynamicpvc.yaml with increased value for 'storage' (ex: 'storage: 10G')

```bash
$ kubectl apply -f testdynamicpvc.yaml
```

Please note that StorageClass used for Dynamic Volume Provisioning has 'allowVolumeExpansion' field set to 'true' for volume expansion to work on newly provisioned volume.

### Snapshotting

Snapshot provisioning is supported for dynamically provisioned volumes only. This provides
 support for creating/deleting HPE Ezmeral Data Fabric snapshot for newly provisioned volumes created with HPE Ezmeral Data Fabric CSI provisioner.
 
Run the following examples from the `examples` directory for Snapshot.

```bash
$ cd examples
```

1) Create Test namespace to run example yamls

```bash
$ kubectl apply -f testnamespace.yaml
```

2) Create Cluster ticket secret
      
   Note: This step is only required when using static provisioning with HPE Ezmeral Data Fabric Secure Cluster.

```bash
$ kubectl create -f testsecureticketsecret.yaml
```

3) Create Rest-secret for HPE Ezmeral Data Fabric CSI provisioner

```bash
$ kubectl create -f testprovisionerrestsecret.yaml
```

4) If not created already, Create StorageClass using HPE Ezmeral Data Fabric CSI storage plugin driver

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
$ cat /var/log/csi-maprkdf/csi-provisioner-<version>.log
```

7) Create Volume SnapshotClass for snapshot

```bash
$ kubectl create -f testvolumesnapshotclass.yaml
```

8) Create Volume Snapshot

```bash
$ kubectl create -f testvolumesnapshot.yaml
```

9) Verify that the snapshot is provisioned on HPE Ezmeral Data Fabric cluster

```bash
$ kubectl get crd
$ kubectl describe volumesnapshotclasses.snapshot.storage.k8s.io -n test-csi
$ kubectl describe volumesnapshots.snapshot.storage.k8s.io -n test-csi
$ kubectl describe volumesnapshotcontents.snapshot.storage.k8s.io -n test-csi
```

The above command will provide `snapshothandle` which is the HPE Ezmeral Data Fabric snapshot being provisioned for given PVC 
 referenced in the Volume Snapshot.

### Snapshot Restore

Snapshot restore is supported for dynamically provisioned volumes. This provides support for creating a new 
 HPE Ezmeral Data Fabric volume from a snapshot of a volume previously created with HPE Ezmeral Data Fabric CSI provisioner.

Run the following example from the `examples` directory to restore the volume created in the Snapshotting section.

```bash
$ cd examples
```

1) Create a PVC (from the snapshot) & create a Pod to use this PVC

```bash
$ kubectl apply -f testvolumesnapshotrestore.yaml
```

2) Verify that the PVC & Pod are created and the requested volume mount has data from the source snapshot

```bash
$ kubectl exec -it <pod> -n test-csi -- ls -l <volume-mount-path>
```

### Raw Block Volume Provisioning

Raw Block volumes can be statically or dynamically provisioned on the latest release of HPE Ezmeral Data Fabric CSI stoarge plugin driver 

Run the following examples from the `examples` directory for dynamic provisioning of Raw Block Volumes.

```bash
$ cd examples
```

1) Create a PVC with 'volumeMode' set to 'Block'

```bash
$ kubectl apply -f testdynamicblockpvc.yaml
```

2) Verify that PV and PVC are bound to each other at this point.

```bash
$ kubectl get pvc -n test-csi
$ kubectl get pv -n test-csi
```

3) Create Pod using above PVC

```bash
kubectl create -f testdynamicblockpod.yaml
```

Note: volumeDevices.devicePath should be specified for raw block volume to be mounted in the pod specification

4) Verify that the Pod created in step(3) has the requested raw block volume device mounted.

```bash
kubectl exec -it <pod> -n test-csi -- df -h <device-mount-path>
```

### Note: Please refer to [Troubleshooting](troubleshooting.md) section for the installation troubleshooting tips.
