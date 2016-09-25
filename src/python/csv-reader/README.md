
This script reads in one or many csv files containing information about minstry meetings.

It assumes that the files have the following four ordered columns:
   - Minister name
   - Date of meeting (stored as a string, formatted arbitrarily)
   - Attendees of meeting (a name or list of names, formatted arbitrarily)
   - Purpose of meeting

A log file is created in the location the script is run named "csv_file_reader.log"
which contains some debugging information.


Running from the command line:

For all files in resources/csv directory:
`python csv_file_reader.py`

For a specific file:
`python csv_file_reader.py -f PM_meetings_jan_mar_14.csv`

Saving output to a named csv file:
`python csv_file_reader.py -o output.csv`
