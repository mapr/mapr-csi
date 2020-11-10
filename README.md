# MapR CSI Storage Plugin

The MapR CSI Storage plugin provides the persistent storage for Application containers. 
For more information, Refer to [MapR CSI Storage Plugin Overview](https://docs.datafabric.hpe.com/home/CSIdriver/csi_overview.html)

Note: Kubernetes or CSI alpha features are not supported.

## MapR CSI Storage Plugin Support Matrix

<table>
  <thead>
    <tr>
      <th>MapR CSI Plugin version</th>
      <th>Supported Kubernetes Version</th>
      <th>Supported OpenShift Version</th>
      <th>CSI Spec version</th>
      <th>LoopbackNFS Version</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>v1.0.0</td>
      <td>>= 1.17.0</td>
      <td>>= 4.4</td>
      <td><a href="https://github.com/container-storage-interface/spec/blob/v1.3.0/spec.md">v1.3.0</a></td>
      <td>6.2.0</td>
    </tr>
  </tbody>
</table>

The released MapR CSI Storage plugin docker images will be published to:  
[maprtech/csi-nfsplugin](https://hub.docker.com/r/maprtech/csi-nfsplugin)  
[maprtech/csi-kdfprovisioner](https://hub.docker.com/r/maprtech/csi-kdfprovisioner)  
[maprtech/csi-nfsdriver](https://hub.docker.com/r/maprtech/csi-nfsdriver)  


For usage, troubleshooting & examples, Refer to [MapR CSI documentation](https://docs.datafabric.hpe.com/home/CSIdriver/csi_using_and_troubleshooting.html)

## Note: For any suggestion, issues or improvements, Please file a github issue.
