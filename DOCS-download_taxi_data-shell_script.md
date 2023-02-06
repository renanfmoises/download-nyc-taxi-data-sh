# `download_nyc_taxi_data` Script Documentation

## NAME

`download_taxi_data` - A script to download taxi trip data and save it in parquet format

## DESCRIPTION

This script downloads taxi trip data from a specified URL and saves it to the specified destination directory in parquet format. The destination directory has the following structure:

```{bash}
BASE_DIR/raw/parquet/<color>/YEAR=<year>/MONTH=<month>
```

## INSTALLATION

To install the `download_taxi_data` script, follow these steps:

- Download the script from the specified URL.
- Make sure that the script has the execution permission. If not, run:

```{bash}
chmod +x download_taxi_data.sh
```

## REQUIREMENTS

- A system with bash shell installed.
- The `wget` command installed.

## USAGE

```{bash}
./download_taxi_data.sh <color> <year> <base_dir> [--overwrite]
```

### Parameters

- `color`: The color of the taxi trip data to download.
- `year`: The year and month of the data to download, comma-separated values. For example `2019,2020`; or `2019-01,2019-02,2019-03`; or `2019-01`.
- `base_dir`: The base directory to save the data, default is data_lake.
- `--overwrite`: The optional flag to overwrite existing files. If not set, the script will skip files that already exist.

## EXAMPLES

```{bash}
./download_taxi_data.sh yellow 2019,2020 data_lake --overwrite
```

```{bash}
./download_taxi_data.sh yellow 2019-01,2019-02,2019-03 data_lake --overwrite
```

```{bash}
./download_taxi_data.sh yellow 2019-01 data_lake --overwrite
```

## AUTHOR

Renan Moises
