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


def remove_whitespace(lines):
    for line_idx, line in enumerate(lines):
        for field_idx, field in enumerate(line):
            lines[line_idx][field_idx] = lines[line_idx][field_idx].strip()
    return lines


def remove_special_chars(lines):
    for line_idx, line in enumerate(lines):
        for field_idx, field in enumerate(line):
            lines[line_idx][field_idx] = lines[line_idx][field_idx].replace('\xb2', '').replace('\xb1', '')
    return lines


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
