import csv
import argparse
import os
import logging


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



def setup_logging():
    logging.basicConfig(filename = "csv_file_reader.log", level = logging.DEBUG)


def read_file(filename):
    lines = []
    f = open(filename, 'rb')
    try:
        reader = csv.reader(f)
        for row in reader:
            lines.append(row)
    except csv.Error:
        logging.warning("error reading this file: %r" % filename)
    finally:
            f.close()
    return lines


def remove_empty_lines(lines):
    data = []
    for line in lines:
        if ''.join(line) != '':
            data.append(line)
    return data


def remove_empty_columns(lines):
    data = []
    for line in lines:
        if (len(line) >= 4):
            trunc_line = []
            for i in range(0, 4):
                trunc_line.append(line[i])
            data.append(trunc_line)
        else:
            logging.info("could not truncate this line %r" % line)
    return data


def remove_line(line, lines):
    if (lines.count(line)) > 0:
        lines.remove(line)
    return lines


def remove_boilerplate(lines):
    header_line = ['Minister', 'Date', 'Name of External Organisation', 'Purpose of meeting']
    header_line_2 = ['Minister', 'Date', 'Name of Organisation', 'Purpose of meeting']

    footer_line_1 = ['Does not normally include meetings with Government bodies such as other Government Departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of devolved or foreign governments', '', '', '']
    footer_line_2 = ['Note', '', '', '']
    footer_line_3 = ['Does not normally include meetings with Government bodies such as other Government departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of Parliament, devolved or foreign governments.', '', '', '']

    lines = remove_line(header_line, lines)
    lines = remove_line(header_line_2, lines)
    lines = remove_line(footer_line_1, lines)
    lines = remove_line(footer_line_2, lines)
    lines = remove_line(footer_line_3, lines)

    return lines


# Some csv files have the minister only in the first row and not in subsequent rows
# In this case, copy the minister's name whilst iterating down until the field is no
# longer blank
def clean_minister_column(lines, filename):
    minister_name = lines[0][0]
    if (minister_name.lower() == 'minister'):
        logging.info("first minister name is %r for %r" % (minister_name, filename))
        logging.info(lines[0])
    for l in lines:
        if (l[0] == ''):
            logging.info("setting minister on line %r to %r" % (l, minister_name))
            l[0] = minister_name
        else:
            minister_name = l[0]
    return lines


def print_lines(lines):
    for l in lines:
        print l


def get_csv_file_lines(filename):
    file_contents = read_file(filename)
    file_contents = remove_empty_lines(file_contents)
    file_contents = remove_empty_columns(file_contents)
    file_contents = remove_boilerplate(file_contents)
    file_contents = clean_minister_column(file_contents, filename)
    return file_contents


if __name__ == '__main__':

    setup_logging()

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
