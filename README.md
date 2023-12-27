# rstudio-google-cloud-workstations
Notes on configuring Google Cloud Workstations with rocker/rstudio

## Environment Settings

As per the comments in the `rocker/rstudio` [`init_userconf.sh`](https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/init_userconf.sh#L21-L93) file, the following environment variables need to be set to run `rocker/rstudio` in rootless mode.

| Variable | Value |
| ---------------- | ----------------|
| `RUNROOTLESS` | `true` |
| `USERID` | `0` |
| `GROUPID` | `0` |
| `DISABLE_AUTH` | `true` |

These environment variables are set in the `Dockerfile` for this custom image.

Additionally, I set the **Run as user** field to `0`.

## How to Connect to RStudio Cloud Workstation

1. In the top search bar of [Google Cloud Console](https://console.cloud.google.com/), search for **Cloud Workstations**
2. In the **Workstations** tab in the left menu, choose the Rstudio notebook you wish to connect to, and click the drop-down arrow beside **LAUNCH**. Select "**Connect to web app on port...**", and set **Remote Port** to `8787`.

![image](https://github.com/Collinbrown95/rstudio-google-cloud-workstations/assets/8021046/46badcfe-a505-4dfe-bd95-a358796bde35)

3. Once the remote port has been changed as per Step 2, select "**OPEN IN NEW WINDOW**".
4. In the bottom-right panel, select **More**, then **Go To Working Directory**. This is necessary because the `rocker/rstudio` image by default does not open in the `/home/` directory where a persistent volume is automatically mounted. I.e. in order to persist files across sessions, it's necessary to save files to the `/home/` directory.

![image](https://github.com/Collinbrown95/rstudio-google-cloud-workstations/assets/8021046/10747ac5-ca00-49e3-9818-04080405331c)

## Reading Data from Google Cloud Storage

The [Apache Arrow R package](https://arrow.apache.org/docs/r/index.html) has native support for [GCS buckets](https://arrow.apache.org/docs/r/articles/fs.html).

By default, the service account of the cloud workstation will be used to authenticate against the GGS storage bucket, so the service account that the cloud workstation runs under requires the appropriate permissions on the GCS storage bucket.

In order to read directories containing many parquet files, an [Arrow Dataset](https://arrow.apache.org/docs/r/reference/Dataset.html) needs to be created over the GCS bucket prefix containing the parquet directory. Given an Arrow Dataset, an [Arrow Scanner](https://arrow.apache.org/docs/r/reference/Scanner.html) is used to iterate over the shards in the parquet directory based on row and column filtering conditions. Finally, the Scanner can be converted into an [Apache Arrow Table](https://arrow.apache.org/docs/cpp/tables.html), which can subsequently be converted to an R Data Frame. This [stackoverflow answer](https://stackoverflow.com/a/67287300) summarizes how these various components fit together.

**Example**

```r
# Install and import arrow R package
install.packages("arrow")

library(arrow)

# Name of gcs bucket to read from
gcs_bucket <- "YOUR_BUCKET_NAME"

# Connect to gcs bucket
tb_bucket <- gs_bucket(gcs_bucket)

# List all objects under a prefix
tb_bucket$ls("cases", recursive = TRUE)

# Load an entire parquet directory from a path

# Create GCS filesystem using service account credentials from the VM
fs <- GcsFileSystem$create()
# Define an Apache Arrow Dataset over a prefix containing one or more parquet
# files
ds <- arrow::open_dataset(fs$path(sprintf("%s/cases", gcs_bucket)))
# Create a Scanner using the Apache Arrow Dataset
so <- Scanner$create(ds)
# Convert Scanner object to an Apache Arrow Table
at <- so$ToTable()
# Convert Arrow Table to R data frame
df <- as.data.frame(at)

# Continue with downstream analysis
```
