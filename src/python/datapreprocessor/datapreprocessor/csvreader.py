import csv
import os


def read_file(filename):
    lines = []
    f = open(filename, 'rb')
    try:
        reader = csv.reader(f)
        for row in reader:
            yield row
    finally:
            f.close()
