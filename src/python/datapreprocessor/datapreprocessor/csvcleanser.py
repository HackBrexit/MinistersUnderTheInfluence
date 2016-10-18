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


def remove_line(line, lines):
    if (lines.count(line)) > 0:
        lines.remove(line)
    return lines


def remove_boilerplate(lines):
    header_line = ['Minister', 'Date', 'Name of External Organisation', 'Purpose of meeting']
    header_line_2 = ['Minister', 'Date', 'Name of Organisation', 'Purpose of meeting']

    footer_line_1 = ['Does not normally include meetings with Government bodies such as other Government Departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of devolved or foreign governments', '', '', '']
    footer_line_2 = ['Note', '', '', '']
    footer_line_3 = ['Does not normally include meetings with Government bodies such as other Government departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of Parliament, devolved or foreign governments.', '', '', '']

    lines = remove_line(header_line, lines)
    lines = remove_line(header_line_2, lines)
    lines = remove_line(footer_line_1, lines)
    lines = remove_line(footer_line_2, lines)
    lines = remove_line(footer_line_3, lines)

    return lines

def cleanse_csv_data(file_contents):
    file_contents = remove_empty_lines(file_contents)
    file_contents = remove_empty_columns(file_contents)
    file_contents = remove_boilerplate(file_contents)
    return file_contents
