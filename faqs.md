FAQs
===============================

### Why auto backup not happening?
Auto backups are postponed when battery is low or your device is on power saving mode. It is also postponed when the user is doing some resource intensive task like playing games. But don't worry, backups are automatically re-attempted whenever the device is idle.

### How can I verify that the APK available on GitHub releases is authentic?
 
Download the safenotes apk from GitHub release and use `apksigner --print-certs safenotes.apk` to get the SHA256 digest of the certificate.
The SHA-256 digest of the certificate should be `0a63d47a2afcf09dcf1a408ff36f6c71950a066532241538bdd97dc588811b50`, as shown in the example below.

```yaml
❯ apksigner verify --print-certs safenotes-2.3.0-all.apk
Signer #1 certificate DN: CN=Safe Notes, OU=Unknown, O=Trisven Networks, L=Unknown, ST=Unknown, C=Unknown
Signer #1 certificate SHA-256 digest: 0a63d47a2afcf09dcf1a408ff36f6c71950a066532241538bdd97dc588811b50
Signer #1 certificate SHA-1 digest: 61685b451876ee0479c07404596f254e387445ac
Signer #1 certificate MD5 digest: 7d98066ad427748b7fba20e238ad5f21
```

> **Note**  
> `apksigner` is a CLI tool available as part of the Android SDK. You can download it from here: https://developer.android.com/studio/index.html#command-line-tools-only


### If you have any new questions do not hesitate to raise issue [here](https://github.com/keshav-space/safenotes/issues/new)
