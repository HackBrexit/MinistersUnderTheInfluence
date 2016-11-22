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
        continue
    if not 'meetings' in filename_lower:
        continue
    if 'gift' in filename_lower:
        continue
    with open(os.path.join(PATH_TO_DATAFILES, filename), 'rU') as file_handle:
        reader = csv.reader(file_handle)
        first_row = True
        org_col = None
        for row in reader:
            if len(row) < 4:
                continue
            if first_row and not row[1]:
                continue
            if first_row:
                first_row = False
                for index, col in enumerate(row):
                    if 'Health' in col:
                        continue
                    if 'organisation' in col.lower() or 'organization' in col.lower():
                        org_col = index
                        break
                if org_col is None:
                    break
                continue
            if org_col < len(row) and row[org_col]:
                org = row[org_col].strip().strip('-').strip()
                if org:
                    orgs[org] += 1

with open('orgs.csv', 'wb') as org_file:
    org_writer = csv.writer(org_file)
    org_writer.writerow(['Organisation', 'Times Seen'])
    for org, count in sorted(orgs.items()):
        org_writer.writerow([org, count])