from collections import defaultdict
import csv
import os

PATH_TO_DATAFILES = os.path.join(
    '..', '..', 'php', 'gov-harvester', 'datafiles'
)


def is_csv_file(filename):
    return filename.endswith('.csv')


def is_a_meetings_file(filename):
    return 'meetings' in filename


def is_not_a_gifts_files(filename):
    return 'gift' not in filename


CAN_PROCESS_FILE_CHECKS = [
    is_csv_file,
    is_a_meetings_file,
    is_not_a_gifts_files,
]


def file_can_be_processed(filename):
    filename_lower = filename.lower()
    return all(check(filename_lower) for check in CAN_PROCESS_FILE_CHECKS)


def row_is_long_enough(row):
    """
    Check we have enough entries to be a data or header row.

    If there's fewer than three columns this row is unlikely to be useful
    Mostly we'd want 4 but sometimes it's meetings for XXX followed by a
    three column version with the other details.
    """
    return len(row) >= 3


def header_row_contains_more_than_one_value(row):
    """
    Check that at least the first two columns of a header have values
    """
    return is_header_row and row[1]


CAN_PROCESS_HEADER_ROW_CHECKS = [
    row_is_long_enough,
    header_row_contains_more_than_one_value,
]


CAN_PROCESS_DATA_ROW_CHECKS = [
    row_is_long_enough,
]


def can_process_row(row, is_header_row):
    if is_header_row:
        return all(check(row) for check in CAN_PROCESS_HEADER_ROW_CHECKS)
    else:
        return all(check(row) for check in CAN_PROCESS_DATA_ROW_CHECKS)


def find_organisation_column_index(row):
    for index, col in enumerate(row):
        if 'Health' in col:
            # Special case, there's one file where this is in the minister
            # heading too.
            continue
        if 'organisation' in col.lower() or 'organization' in col.lower():
            return index
    return None


orgs = defaultdict(lambda: 0)
for filename in os.listdir(PATH_TO_DATAFILES):
    if not file_can_be_processed(filename):
        continue
    with open(os.path.join(PATH_TO_DATAFILES, filename), 'rU') as file_handle:
        reader = csv.reader(file_handle)
        is_header_row = True
        org_col = None
        for row in reader:
            if not can_process_row(row, is_header_row):
                continue
            if is_header_row:
                org_col = find_organisation_column_index(row)
                if org_col is None:
                    # If there wasn't an 'organisation' column then skip to the next file
                    break
                is_header_row = False
                continue
            if org_col < len(row) and row[org_col]:
                # If the current row has enough columns extract the organisation
                # and clean it up
                org = row[org_col].strip().strip('-').strip()
                if org:
                    # Increment the organisation's meeting count
                    orgs[org] += 1

with open('orgs.csv', 'wb') as org_file:
    org_writer = csv.writer(org_file)
    org_writer.writerow(['Organisation', 'Times Seen'])
    for org, count in sorted(orgs.items()):
        org_writer.writerow([org, count])