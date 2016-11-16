UNWANTED_SPECIAL_CHARS = "".join([
    '\xb1', '\xb2'
])


def is_row_empty(row):
    return not any(row)


def remove_excess_columns_from_row(row):
    return row[:4]


def remove_extra_whitespace_from_row(row):
    return [cell.strip() for cell in row]


def remove_special_chars_from_row(row):
    return [cell.translate(None, UNWANTED_SPECIAL_CHARS) for cell in row]


def is_row_boilerplate(row):
    return (
        (row[0] == 'Minister' and row[1] == 'Date') or
        row[0] == 'Note' or
        'Does not normally include' in row[0]
    )


def cleanse_row(row):
    row_data = remove_excess_columns_from_row(row)
    row_data = remove_special_chars_from_row(row_data)
    row_data = remove_extra_whitespace_from_row(row_data)

    if is_row_empty(row_data) or is_row_boilerplate(row_data):
        return None
    return row_data


def cleanse_csv_data(file_contents):
    return filter(None, (cleanse_row(row) for row in file_contents))
