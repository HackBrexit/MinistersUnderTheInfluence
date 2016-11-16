UNWANTED_SPECIAL_CHARS = "".join([
    '\xb1', '\xb2'
])


def remove_empty_lines(lines):
    data = []
    for line in lines:
        if ''.join(line) != '':
            data.append(line)
    return data


def remove_empty_columns(lines):
    data = []
    for line in lines:
        if (len(line) >= 4):
            trunc_line = []
            for i in range(0, 4):
                trunc_line.append(line[i])
            data.append(trunc_line)
    return data


def remove_extra_whitespace_from_row(row):
    return [cell.strip() for cell in row]


def remove_whitespace(rows):
    return [remove_extra_whitespace_from_row(row) for row in rows]


def remove_special_chars_from_row(row):
    return [cell.translate(None, UNWANTED_SPECIAL_CHARS) for cell in row]


def remove_special_chars(rows):
    return [remove_special_chars_from_row(row) for row in rows]


def remove_line(predicate, lines):
    return [l for l in lines if not predicate(l)]

def remove_boilerplate(lines):
    lines = remove_line(lambda l: l == ['Minister', 'Date', 'Name of Organisation', 'Purpose of meeting'], lines)
    lines = remove_line(lambda l: l == ['Minister', 'Date', 'Name of External Organisation', 'Purpose of meeting'], lines)
    lines = remove_line(lambda l: 'Does not normally include' in l[0], lines)
    lines = remove_line(lambda l: l[0] == 'Note', lines)
    return lines

def cleanse_csv_data(file_contents):
    file_contents = remove_empty_lines(file_contents)
    file_contents = remove_empty_columns(file_contents)
    file_contents = remove_whitespace(file_contents)
    file_contents = remove_special_chars(file_contents)
    file_contents = remove_boilerplate(file_contents)
    return file_contents
