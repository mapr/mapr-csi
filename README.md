# MapR CSI Storage Plugin

The MapR CSI Storage plugin provides the persistent storage for Application containers. 
For more information, Refer to [MapR CSI Storage Plugin Overview](https://docs.datafabric.hpe.com/61/CSIdriver/csi_overview.html)

Note: Kubernetes or CSI alpha features are not supported on MapR CSI Storage plugin v1.1.0.

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
      <td>v1.1.0</td>
      <td>>=1.16.0</td>
      <td><a href="https://github.com/container-storage-interface/spec/blob/v1.3.0/spec.md">v1.3.0</a></td>
      <td>6.1.0</td>
    </tr>
  </tbody>
</table>

The released MapR CSI Storage plugin docker images will be published to:  
[maprtech/csi-kdfplugin](https://hub.docker.com/r/maprtech/csi-kdfplugin)  
[maprtech/csi-kdfprovisioner](https://hub.docker.com/r/maprtech/csi-kdfprovisioner)  
[maprtech/csi-kdfdriver](https://hub.docker.com/r/maprtech/csi-kdfdriver)  


For usage, troubleshooting & examples, Refer to [MapR CSI documentation](https://docs.datafabric.hpe.com/61/CSIdriver/csi_using_and_troubleshooting.html)

## Note: For any suggestion, issues or improvements, Please file a github issue.
