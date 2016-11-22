import argparse
import json
import os
import csvreader
import datanormaliser
import csvcleanser
from datetime import datetime

# This script reads in one or many csv files containing information about minstry meetings.
# It assumes that the files have the following four ordered columns:
#   - Minister name
#   - Date of meeting (stored as a string, formatted arbitrarily)
#   - Attendees of meeting (a name or list of names, formatted arbitrarily)
#   - Purpose of meeting
# A log file is created in the location the script is run named "csv_file_reader.log"
# which some debugging information.


# Running from the command line:

# For all files in resources/csv directory:
# python csv_file_reader.py

# For a specific file:
# python csv_file_reader.py -f PM_meetings_jan_mar_14.csv

# Saving output to a named csv file:
# python csv_file_reader.py -o output.csv


def print_lines(lines):
    for l in lines:
        print l


def process_csv_file(filename, error_collection):
    file_info = datanormaliser.extract_info_from_filename(filename)
    current_minister = None
    new_rows = []
    row_index = 0
    for row in csvreader.read_file(filename):
        try:
            row_index += 1
            clean_row_data = csvcleanser.cleanse_row(row)
            if clean_row_data is None:
                # row didn't contain useful data.
                continue
            new_row, current_minister = datanormaliser.normalise_row(
                clean_row_data, file_info['year'], current_minister
            )
            yield new_row
        except Exception, e:
            error_collection.append({
                'filename': filename,
                'row_index': row_index,
                'row_data': row,
                'exception': repr(e),
                'type': 'row_error',
            })


def process_files(filenames, error_collection):
    for filename in filenames:
        try:
            lines = process_csv_file(filename, errors)
            print_lines(lines)
        except Exception, e:
            error_collection.append({
                'filename': filename,
                'exception': repr(e),
                'type': 'file_error',
            })


if __name__ == '__main__':

    processing_start = datetime.now() 
    errors = []

    parser = argparse.ArgumentParser()
    parser.add_argument('-f')
    args = parser.parse_args()

    print args

    filenames = []
    if args.f:
        filenames.append(args.f)
    else:
        filenames += [
            '../../../resources/csv/{}'.format(filename)
            for filename in os.listdir('../../../resources/csv')
            if filename.endswith('.csv')
        ]
    process_files(filenames, errors)

    if errors:
        error_log_filename = 'processing_errors_{:%Y%m%d%H%M%S}.json'.format(
            processing_start
        )
        if not os.path.exists('logs'):
            os.mkdir('logs')
        with open(os.path.join('logs', error_log_filename), 'w') as file_handle:
            json.dump(errors, file_handle, indent=2)
