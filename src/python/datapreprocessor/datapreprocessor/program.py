import argparse
import os
import csvreader
import datanormaliser
import csvcleanser

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


def process_csv_file(filename):
    file_info = datanormaliser.extract_info_from_filename(filename)
    current_minister = None
    new_rows = []
    for row in csvreader.read_file(filename):
        clean_row_data = csvcleanser.cleanse_row(row)
        if clean_row_data is None:
            # row didn't contain useful data.
            continue
        new_row, current_minister = datanormaliser.normalise_row(
            clean_row_data, file_info['year'], current_minister
        )
        yield row


if __name__ == '__main__':

    def run_file(filename):
        lines = process_csv_file(filename)
        print_lines(lines)

    parser = argparse.ArgumentParser()
    parser.add_argument('-f')
    args = parser.parse_args()

    print args

    if args.f:
        run_file(args.f)
    else:
        for fn in os.listdir('../../../resources/csv'):
            if not fn.endswith('.csv'):
                continue
            run_file('../../../resources/csv/%s' % fn)
