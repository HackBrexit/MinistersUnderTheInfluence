from collections import defaultdict
import csv
import os

PATH_TO_DATAFILES = os.path.join(
    '..', '..', 'php', 'gov-harvester', 'datafiles'
)


orgs = defaultdict(lambda: 0)
for filename in os.listdir(PATH_TO_DATAFILES):
    filename_lower = filename.lower()
    if not filename_lower.endswith('.csv'):
        # Skip the file if it's not a csv
        continue
    if not 'meetings' in filename_lower:
        # Skip the file if it doesn't contain a meeting of some sort
        continue
    if 'gift' in filename_lower:
        # Skip the file if it also contains gift information
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