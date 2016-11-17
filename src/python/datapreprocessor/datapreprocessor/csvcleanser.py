# List of characters to be removed from data
_UNWANTED_SPECIAL_CHARS = "".join([
    '\xb1', '\xb2'
])


def _is_row_empty(row):
    """
    Check to see if the row contains nothing but empty cells.
    """
    return not any(row)


def _remove_excess_columns_from_row(row):
    """
    Remove padding from the end of rows.

    Sometimes a csv will have been padded out with extra cells beyond the
    limit of those the data is put in. This just removes them.

    Note:
    For meetings the number of cells we expect to see is 4
    """
    return row[:4]


def _remove_extra_whitespace_from_row(row):
    """
    Trim any leading or trailing whitespace from the cells in a row.
    """
    return [cell.strip() for cell in row]


def _remove_special_chars_from_row(row):
    """
    Remove any characters we don't want to see from the cells in a row.

    Uses the python translate function for removing characters.
    The list of characters to be removed comes from the constant declared
    at the top of the file `_UNWANTED_SPECIAL_CHARS`.

    See https://docs.python.org/2/library/string.html#string.translate for more
    info on the translate function.
    """
    return [cell.translate(None, _UNWANTED_SPECIAL_CHARS) for cell in row]


def _is_row_boilerplate(row):
    """
    Check if the row is boilerplate (a heading or footer row mostly)

    Inspects the data in the row to determine if it's a useful data row or just
    some text that can be ignored.
    """
    return (
        (row[0] == 'Minister' and row[1] == 'Date') or
        row[0] == 'Note' or
        'Does not normally include' in row[0]
    )


def cleanse_row(row):
    """
    Cleanse a row from excess characters and indicate if it's useful

    Removes extra columns, special characters and whitespace then returns
    the data if deemed useful (not empty and not boilerplate) otherwise
    return None if the row is not useful.
    """
    row_data = _remove_excess_columns_from_row(row)
    row_data = _remove_special_chars_from_row(row_data)
    row_data = _remove_extra_whitespace_from_row(row_data)

    if _is_row_empty(row_data) or _is_row_boilerplate(row_data):
        return None
    return row_data


def cleanse_csv_data(file_contents):
    """
    Take a list of rows from a file and return a list of cleaned data rows.
    """
    return filter(None, (cleanse_row(row) for row in file_contents))
