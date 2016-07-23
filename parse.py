import re
import csv


def main():

    startWithNote = re.compile("^Note")

    with open("./ministerial-data-cabinet-office/data/bmmeetingsjanmar2013.csv",'r') as file:
        csvReader = csv.reader(file,delimiter=',',quotechar='\"')

        minister = "";

        for line in csvReader:
            if(startWithNote.match(line[0])):
                break

            if(not len(line[0]) == 0):
                minister = line[0]

            if(not isBlankLine(line)):
                writeToFile(line,minister)


def isBlankLine(columns):
    return(len(columns[1])==0 and len(columns[2])==0)

def writeToFile(line,minister):
    writeMinisters(minister)
    # print(line, minister)
    orgs = line[2].split(",")
    # print(orgs)
    writeOrgs(orgs)
    #TODO:  with open(myFile, 'a') as file:
        #if first thing is empty add person
        # file.write((',').join(line))
def writeMinisters(minister):
    with open("ministers.csv","a") as f:
        print(minister)
        f.write(minister+"\n")

def writeOrgs(orgs):
    with open("orgs.csv","a") as f:
        for org in orgs:
            print(org)
            f.write(org+"\n")

main()