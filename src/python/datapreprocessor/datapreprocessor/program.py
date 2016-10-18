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


def get_csv_file_lines(filename):
    file_contents = csvreader.read_file(filename)
    file_contents = csvcleanser.cleanse_csv_data(file_contents)
    file_contents = datanormaliser.normalise(file_contents)
    return file_contents


if __name__ == '__main__':

    def run_file(filename):
        lines = get_csv_file_lines(filename)
        print_lines(lines)

    parser = argparse.ArgumentParser()
    parser.add_argument('-f')
    args = parser.parse_args()

    print args

    if args.f:
        run_file(args.f)
    else:
        for fn in os.listdir('../../../resources/csv'):
            run_file('../../../resources/csv/%s' % fn)
