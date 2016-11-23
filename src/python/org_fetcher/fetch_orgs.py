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
    is_not_a_gifts_files
]


def file_can_be_processed(filename):
    filename_lower = filename.lower()
    return all(check(filename_lower) for check in CAN_PROCESS_FILE_CHECKS)


orgs = defaultdict(lambda: 0)
for filename in os.listdir(PATH_TO_DATAFILES):
    if not file_can_be_processed(filename):
        continue
    with open(os.path.join(PATH_TO_DATAFILES, filename), 'rU') as file_handle:
        reader = csv.reader(file_handle)
        first_row = True
        org_col = None
        for row in reader:
            if len(row) < 3:
                # If there's fewer than three columns this row is unlikely to be useful
                # Mostly we'd want 4 but sometimes it's meetings for XXX followed by a
                # three column version with the other details.
                continue
            if first_row and not row[1]:
                # If the first row isn't full of headings then skip it and treat the
                # next as if it's a heading
                continue
            if first_row:
                # When looking at the heading row, scan across to find the column with
                # the organisations in.
                first_row = False
                for index, col in enumerate(row):
                    if 'Health' in col:
                        # Special case, there's one file where this is in the minister
                        # heading too.
                        continue
                    if 'organisation' in col.lower() or 'organization' in col.lower():
                        org_col = index
                        break
                if org_col is None:
                    # If there wasn't an 'organisation' column then skip to the next file
                    break
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