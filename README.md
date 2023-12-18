# rstudio-google-cloud-workstations
Notes on configuring Google Cloud Workstations with rocker/rstudio

## Environment Settings

As per the comments in the `rocker/rstudio` [`init_userconf.sh`](https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/init_userconf.sh#L21-L93) file, the following environment variables need to be set to run `rocker/rstudio` in rootless mode.

| Variable | Value |
| ---------------- | ----------------|
| `RUNROOTLESS` | `true` |
| `USER` | `root` |
| `PASSWORD` | Whatever password you want to use to sign into the RStudio instance |
| `USERID` | `0` |
| `GROUPID` | `0` |
| `EDITOR_FOCUS_DIR` | "/home" |

Additionally, I set the **Run as user** field to `0` and **Working directory** to `/root`.

## How to Connect to RStudio Cloud Workstation

1. In the top search bar of [Google Cloud Console](https://console.cloud.google.com/), search for **Cloud Workstations**
2. In the **Workstations** tab in the left menu, choose the Rstudio notebook you wish to connect to, and click the drop-down arrow beside **LAUNCH**. Select "**Connect to web app on port...**", and set **Remote Port** to `8787`.

![image](https://github.com/Collinbrown95/rstudio-google-cloud-workstations/assets/8021046/46badcfe-a505-4dfe-bd95-a358796bde35)


3. Once the remote port has been changed as per Step 2, select "**OPEN IN NEW WINDOW**".
4. Enter the Username and Password provided to you via email.

## Reading Data from Google Cloud Storage

The [Apache Arrow R package](https://arrow.apache.org/docs/r/index.html) has native support for [GCS buckets](https://arrow.apache.org/docs/r/articles/fs.html).

By default, the service account of the cloud workstation will be used to authenticate against the GGS storage bucket, so the storage account that the cloud workstation runs under requires the appropriate permissions on the GCS storage bucket.
