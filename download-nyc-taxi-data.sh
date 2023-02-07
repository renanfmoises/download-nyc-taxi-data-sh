#!/bin/bash

##########################################################################################################################
##########################################################################################################################
#####
##### DOWNLOAD_NYC_TAXI_DATA(1)
#####
##### NAME
#####        download-nyc-taxi-data.sh - script to download taxi trip data and save it in parquet format
#####
##### SYNOPSIS
#####        ./download-nyc-taxi-data.sh <color> <year> <base_dir> [--overwrite]
#####
##### DESCRIPTION
#####        This script downloads taxi trip data from the specified URL and saves it to the specified
#####        destination directory in parquet format. The destination directory has a structure:
#####        BASE_DIR/raw/parquet/<color>/YEAR=<year>/MONTH=<month>
#####
#####        color: The color of the taxi trip data to download.
#####
#####        year: The year and month of the data to download, comma-separated values.
#####              For example, 2019,2020 or 2019-01,2019-02,2019-03 or 2019-01.
#####
#####        base_dir: The base directory to save the data, default is data_lake.
#####
#####        --overwrite: The optional flag to overwrite existing files. If not set, the script will skip
#####                     files that already exist.
#####
##### EXAMPLES
#####        ./download-nyc-taxi-data.sh yellow 2019,2020 myDataDir --overwrite
#####        ./download-nyc-taxi-data.sh yellow 2019-01,2019-02,2019-03 data_lake --overwrite
#####        ./download-nyc-taxi-data.sh yellow 2019-01
#####
##### AUTHOR
#####     Written by: Renan Moises
#####
##########################################################################################################################
##########################################################################################################################


# URL to download taxi trip data
URL="https://d37ci6vzurychx.cloudfront.net/trip-data/{color}_tripdata_{YYYY}-{mm}.parquet"

# Default destination directory
BASE_DIR="${3:-data_lake}"

# Color of the taxi trip data
color="$1"

# Year and month of the data to download (comma-separated values)
years_and_months="$2"

# Flag to overwrite existing files
overwrite=false

if [ "$4" == "--overwrite" ]; then
  overwrite=true
fi

# Check for BASE_DIR argument
if [ "$BASE_DIR" == "--overwrite" ]; then
  echo "ERROR: Invalid value for BASE_DIR. When overwrite flag is set, BASE_DIR must be specified."
  exit 1
fi

# Check for color argument
if [ -z "$color" ]; then
  echo "ERROR: Color argument not provided."
  exit 1
fi

case $color in
  yellow | green) ;;
  *) echo "ERROR: Invalid color argument. Must be either 'yellow' or 'green'."
     exit 1;;
esac

# Check for years_and_months argument
if [ -z "$years_and_months" ]; then
  echo "ERROR: Years and months argument not provided."
  exit 1
fi

# Split the year-month values into an array
IFS=',' read -r -a year_month_array <<< "$years_and_months"

# Loop through each year-month or year
for year_month in "${year_month_array[@]}"; do
  # Case: Single year-month specified (e.g., 2019-01)
  if [[ $year_month == *"-"* ]]; then
    year="${year_month%-*}"
    month="${year_month#*-}"

    # Construct URL
    file_url="${URL//\{color\}/$color}"
    file_url="${file_url//\{YYYY\}/$year}"
    file_url="${file_url//\{mm\}/$month}"

    # Construct destination directory path
    file_destination="$BASE_DIR/raw/parquet/$color/YEAR=$year/MONTH=$(printf '%02d' $month)/"

    # Create directory if it doesn't exist
    if [ ! -d "$file_destination" ]; then
      mkdir -p "$file_destination"
    fi

    # Construct destination file path
    file_destination="$file_destination/$color"_tripdata_"$year-$(printf '%02d' $month).parquet"

    # Check if file already exists and overwrite flag is not set
    if [ -f "$file_destination" ] && [ "$overwrite" = false ]; then
      echo "File already exists and overwrite flag not set, skipping $file_destination"
    else
      file_name="${file_url##*/}"
      file_destination_dir="${file_destination%/*}"
      echo "[INFO] Downloading $file_name to $file_destination_dir"
      wget --spider --no-verbose "$file_url"  # Check if file exists before downloading
      if [ $? -ne 0 ]; then
        echo "ERROR: File does not exist at $file_url"
        exit 1
      fi
      wget -q --show-progress "$file_url" -O "$file_destination"
      echo ""
    fi

  # Case: Single year specified (e.g., 2019)
  else
    year="$year_month"
    # Loop through each month in a year
    for month in {01..12}; do
      # Format month with leading zero (e.g., 01)
      month="$(printf '%02d' $month)"

      # Construct URL
      file_url="${URL//\{color\}/$color}"
      file_url="${file_url//\{YYYY\}/$year}"
      file_url="${file_url//\{mm\}/$month}"

      # Construct destination directory path
      file_destination="$BASE_DIR/raw/parquet/$color/YEAR=$year/MONTH=$month/"

      # Create directory if it doesn't exist
      if [ ! -d "$file_destination" ]; then
        mkdir -p "$file_destination"
      fi

      # Construct destination file path
      file_destination="$file_destination/$color"_tripdata_"$year-$month.parquet"

      # Check if file already exists and overwrite flag is not set
      if [ -f "$file_destination" ] && [ "$overwrite" = false ]; then
        echo "File already exists and overwrite flag not set, skipping $file_destination"
      else
        file_name = "${file_url##*/}"
        file_destination_dir="${file_destination%/*}"
        echo "[INFO] Downloading $file_name to $file_destination"
        wget --spider --no-verbose "$file_url"  # Check if file exists before downloading
        if [ $? -ne 0 ]; then
          echo "ERROR: File does not exist at $file_url"
          exit 1
        fi
        wget -q --show-progress "$file_url" -O "$file_destination"
        echo ""
      fi
    done
  fi
done
echo "[INFO] Finished downloading $color taxi trip data."
