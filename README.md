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

Additionally, I set the **Run as user** field to `0` and **Working directory** to `/root`.
