# download-nyc-taxi-data

`download-nyc-taxi-data.sh` - A script to download taxi trip data and save it in parquet format.

## Table of Contents

- [download-nyc-taxi-data](#download-nyc-taxi-data)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Inputs](#inputs)
    - [Options](#options)
  - [File Structure](#file-structure)
  - [Examples](#examples)
  - [Notes](#notes)
  - [Author](#author)

## Requirements

- bash shell
- `wget` command installed

## Installation

1. Clone the repository or download the script file.
2. Make the script file executable by running the following command in your terminal:

    ```bash
    chmod +x [script-file-name].sh
    ```

3. Run the script with the required arguments.
4. (Optional) Add the script to your `PATH` environment variable to run it from anywhere.

## Usage

To run the script, execute the following command in the terminal:

```bash
./download-nyc-taxi-data.sh [color] [years_and_months] [BASE_DIR] [--overwrite]
```

### Inputs

1. `color`: Color of the taxi trip data.
2. `years_and_months`: Comma-separated values of the year and/or year-month of the data to download. See [Examples](#examples) for reference.
1. `BASE_DIR`: Destination directory for storing the downloaded data. (default: `data_lake`)

### Options

- `--overwrite`: flag to overwrite existing files.

## File Structure

The script will create a directory structure based on the `BASE_DIR` input as follows:

```bash
BASE_DIR/
  raw/
    parquet/
      [color]/
        YEAR=[year]/
          MONTH=[month]/
            [color]tripdata[year]-[month].parquet
```

## Examples

1. To download green taxi trip data for January 2019 and store it in the `data_lake` directory:

    ```bash
    ./download-nyc-taxi-data.sh green 2019-01
    ```

2. To download yellow taxi trip data for all months in 2020 and store it in the `taxi_data` directory:

    ```bash
    ./download-nyc-taxi-data.sh yellow 2020 taxi_data
    ```

3. To download January, February and March of 2019 and store it in the `data_lake` directory, overwriting existing files:

    ```bash
    ./download_taxi_data.sh yellow 2019-01,2019-02,2019-03 data_lake --overwrite
    ```

## Notes

- The script uses `wget` to download the data, so make sure it is installed on your system.
- If the specified year and month data file already exists in the destination directory and the `--overwrite` flag is not set, the script will skip downloading that file.

## Author

Renan Moises
