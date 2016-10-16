from dateutil.parser import *
from datetime import *
import re

# Some csv files have the minister only in the first row and not in subsequent rows
# In this case, copy the minister's name whilst iterating down until the field is no
# longer blank
def clean_minister_column(lines, filename):
    minister_name = lines[0][0]
    for l in lines:
        if (l[0] == ''):
            l[0] = minister_name
        else:
            minister_name = l[0]
    return lines

def clean_dates(lines):
    # IMPORTANT: This method currently only expects dates of months with or without a year (does not expect days, does not expect empty months !!!)
    # Edge case not included: Jan/Feb/Mar - we must decide how to handle
    # Edge case included: Sept is not recognized so changed to Sep
    SEPT_PATTERN = re.compile("^sept$", flags=re.IGNORECASE) #RegEx to find "Sept" abbreviation
    DEFAULT = datetime(1000,12,01,0,0)  #Default date for dateutil to fill in missing gaps, year 1000

    for idx,line in enumerate(lines):
        date = line[1]
        date = re.sub(SEPT_PATTERN,"Sep",line[1])

        # parse date using dateutil lib
        try:
            newdate = parse(date.replace("-"," of "),default=DEFAULT,dayfirst=True)
        except:
            newdate = ""

        # If no data or date
        if(len(str(newdate))==0 or len(date)==0):
            datestring="XXXX-XX-XX"
        else:
            datestring=""
            # YEAR - if default then missing
            if(newdate.year==1000):
                datestring+="XXXX-"
            else:
                datestring+=str(newdate.year)+"-"
            # MONTH AND DAY - assumed always present and missing respectively (for now)
            datestring += str(newdate.month).zfill(2) + "-XX"

        # print date + " parsed: " + str(newdate) + " is " + datestring

        #Replace date in data
        lines[idx][1]=datestring

    return lines
