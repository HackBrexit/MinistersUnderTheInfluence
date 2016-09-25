import re
import csv
import sys

def main():
    inputfile = ""
    print(sys.argv)
    if(len(sys.argv)>1):
        inputfile = sys.argv[1]

    startWithNote = re.compile("^Note")
    year = getYearFromFilename(inputfile)

    with open(inputfile,'r') as file:

        csvReader = csv.reader(file,delimiter=',',quotechar='\"')

        minister = "";
        next(csvReader,None)

        for line in csvReader:
            if(startWithNote.match(line[0])):
                break

            if(not len(line[0]) == 0):
                minister = line[0]

            if(not isBlankLine(line)):
                writeToFile(line,minister,year,inputfile)


def isBlankLine(line):
    return(len(line[1])==0 and len(line[2])==0)

def writeToFile(cols,minister,year,inputfile):
    with open("combinedmeetings.csv",'a') as newFile:
        csvWriter = csv.writer(newFile, delimiter=',', quotechar='\"')
        if(len(cols)==4):
            if(len(cols[0])==0):#if first thing is empty
                csvWriter.writerow([minister]+cols[1:]+[year]+[inputfile])
            else:
                csvWriter.writerow(cols+[year]+[inputfile])
        else:
            if(len(cols[0])==0):#if first thing is empty
                csvWriter.writerow([minister]+cols[1:-1]+[year]+[inputfile])
            else:
                csvWriter.writerow(cols[:-1]+[year]+[inputfile])



    # writeMinisters(minister)
    # print(line, minister)
    # orgs = line[2].split(",")
    # print(orgs)
    # writeOrgs(orgs)
    #TODO:  with open(myFile, 'a') as file:
        #if first thing is empty add person
        # file.write((',').join(line))

def writeMinisters(minister):
    with open("ministers.csv","a") as f:
        # print(minister)
        f.write(minister.strip()+"\n")

def writeOrgs(orgs):
    with open("orgs.csv","a") as f:
        for org in orgs:
            # print(org)
            f.write(org.strip()+"\n")

def getYearFromFilename(inputfile):
    matchYear = re.compile("[0-9][0-9]+")
    year = re.findall(matchYear,str(inputfile))
    if(len(year)==1):
        if(len(year[0])==4):
            print(year[0])
            return year[0]
        else:
            return("20"+year[0])


main()