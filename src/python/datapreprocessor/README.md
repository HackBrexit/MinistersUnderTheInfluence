
This script reads in one or many csv files containing information about ministry meetings.

It assumes that the files have the following four ordered columns:
   - Minister name
   - Date of meeting (stored as a string, formatted arbitrarily)
   - Attendees of meeting (a name or list of names, formatted arbitrarily)
   - Purpose of meeting


Running from the command line:

For all files in resources/csv directory:
`python csv_file_reader.py`

For a specific file:
`python csv_file_reader.py -f PM_meetings_jan_mar_14.csv`

Running tests:
You may need to install nosetests on your system first.
From the directory `src/python/datapreprocessor` run the command `nosetests`
