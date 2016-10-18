import csv
import os


def read_file(filename):
    lines = []
    f = open(filename, 'rb')
    try:
        reader = csv.reader(f)
        for row in reader:
            lines.append(row)
    finally:
            f.close()
    return lines
