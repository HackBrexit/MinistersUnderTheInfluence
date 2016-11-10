from dateutil.parser import *
from datetime import *
import re

DATA_TYPES = ['gifts', 'hospitality', 'meetings', 'travel']

class TypeNotFoundException(Exception):
    pass

class MultipleTypesFoundException(Exception):
    
    def __init__(self, type_keys):
        self.type_keys = type_keys

# Some csv files have the minister only in the first row and not in subsequent rows
# In this case, copy the minister's name whilst iterating down until the field is no
# longer blank
def clean_minister_column(lines):
    minister_name = lines[0][0]
    for l in lines:
        if (l[0] == ''):
            l[0] = minister_name
        else:
            minister_name = l[0]
    return lines

def has_year(newdate):
    if newdate.year != 1000:
        return newdate.year
    else:
        return None

def has_month(date, newdate):
    month_info = date.join(re.findall("[a-zA-Z]+", date))
    if len(month_info) != 0:
        return newdate.month
    else:
        return None

def has_day(date, newdate):
    numbers_present = [int(n) for n in date.split() if n.isdigit()]
    if ((newdate.year != 1000  and (len(numbers_present) == 2)) or (newdate.year == 1000 and (len(numbers_present) == 1))):
        return newdate.day
    else:
        return None

def clean_dates(lines):
    # IMPORTANT: This method currently only expects dates of months with or without a year
    # Edge case included: Sept is not recognized so changed to Sep
    SEPT_PATTERN = re.compile("^sept$", flags=re.IGNORECASE) #RegEx to find "Sept" abbreviation
    DEFAULT = datetime(1000,12,01,0,0)  #Default date for dateutil to fill in missing gaps, year 1000

    for idx,line in enumerate(lines):
        date = line[1]
        date = re.sub(SEPT_PATTERN,"Sep",line[1])
        dateInfo = {}

        if(len(date)==0):
            lines[idx][1]= {'Year': None, 'Month': None, 'Day': None}
        else:
            newdate = parse(date.replace("-"," of "),default=DEFAULT,dayfirst=True)
            dateInfo = {'Year': has_year(newdate), 'Month': has_month(date, newdate), 'Day': has_day(date, newdate)}
            lines[idx][1] = dateInfo

    return lines

def normalise(file_contents):
    file_contents = clean_minister_column(file_contents)
    file_contents = clean_dates(file_contents)
    return file_contents

def extract_info_from_filename(filename, type_strings=DATA_TYPES):
    type_keys = [type_ for type_ in type_strings if type_ in filename]
    if not type_keys:
        raise TypeNotFoundException()
    elif len(type_keys) > 1:
        raise MultipleTypesFoundException(type_keys)

    return {
        'date': None,
        'type': type_keys[0],
    }