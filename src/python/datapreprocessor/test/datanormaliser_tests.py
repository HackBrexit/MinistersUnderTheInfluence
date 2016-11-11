import unittest
from datapreprocessor.datanormaliser import *

class DataNormaliserTest(unittest.TestCase):

    def test_missing_minister_names_are_filled_in(self):
        minister_name = "Harry Potter"
        another_minister_name = "Frodo Baggins"

        test_data = [
            [minister_name, 'Jan', 'An attendee', 'A purpose'],
            ['', 'Jan', 'An attendee', 'A purpose'],
            ['', 'Jan', 'An attendee', 'A purpose'],
            ['', 'Jan', 'An attendee', 'A purpose'],
            [another_minister_name, 'Jan', 'An attendee', 'A purpose'],
            ['', 'Jan', 'An attendee', 'A purpose'],
        ]

        normalised = normalise(test_data)
        print normalised[0][0]
        self.assertEqual(minister_name, normalised[0][0])
        self.assertEqual(minister_name, normalised[1][0])
        self.assertEqual(minister_name, normalised[2][0])
        self.assertEqual(minister_name, normalised[3][0])

        self.assertEqual(another_minister_name, normalised[4][0])
        self.assertEqual(another_minister_name, normalised[5][0])

    def test_dates_which_have_whole_month_name_and_year(self):
        test_data = [
            ['Minister name', 'January 2011', 'People', 'Purpose'],
            ['Minister name', 'February 2011', 'People', 'Purpose'],
            ['Minister name', 'March 2011', 'People', 'Purpose'],
            ['Minister name', 'April 2011', 'People', 'Purpose'],
            ['Minister name', 'May 2011', 'People', 'Purpose'],
            ['Minister name', 'June 2011', 'People', 'Purpose'],
            ['Minister name', 'July 2011', 'People', 'Purpose'],
            ['Minister name', 'August 2011', 'People', 'Purpose'],
            ['Minister name', 'September 2011', 'People', 'Purpose'],
            ['Minister name', 'October 2011', 'People', 'Purpose'],
            ['Minister name', 'November 2011', 'People', 'Purpose'],
            ['Minister name', 'December 2011', 'People', 'Purpose'],
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': 2011, 'Month': 1, 'Day': None}, normalised[0][1])
        self.assertEqual({'Year': 2011, 'Month': 2, 'Day': None}, normalised[1][1])
        self.assertEqual({'Year': 2011, 'Month': 3, 'Day': None}, normalised[2][1])
        self.assertEqual({'Year': 2011, 'Month': 4, 'Day': None}, normalised[3][1])
        self.assertEqual({'Year': 2011, 'Month': 5, 'Day': None}, normalised[4][1])
        self.assertEqual({'Year': 2011, 'Month': 6, 'Day': None}, normalised[5][1])
        self.assertEqual({'Year': 2011, 'Month': 7, 'Day': None}, normalised[6][1])
        self.assertEqual({'Year': 2011, 'Month': 8, 'Day': None}, normalised[7][1])
        self.assertEqual({'Year': 2011, 'Month': 9, 'Day': None}, normalised[8][1])
        self.assertEqual({'Year': 2011, 'Month': 10, 'Day': None}, normalised[9][1])
        self.assertEqual({'Year': 2011, 'Month': 11, 'Day': None}, normalised[10][1])
        self.assertEqual({'Year': 2011, 'Month': 12, 'Day': None}, normalised[11][1])

    def test_date_which_have_whole_month_name_but_are_missing_years(self):
        test_data = [
            ['Minister name', 'January', 'People', 'Purpose'],
            ['Minister name', 'February', 'People', 'Purpose'],
            ['Minister name', 'March', 'People', 'Purpose'],
            ['Minister name', 'April', 'People', 'Purpose'],
            ['Minister name', 'May', 'People', 'Purpose'],
            ['Minister name', 'June', 'People', 'Purpose'],
            ['Minister name', 'July', 'People', 'Purpose'],
            ['Minister name', 'August', 'People', 'Purpose'],
            ['Minister name', 'September', 'People', 'Purpose'],
            ['Minister name', 'October', 'People', 'Purpose'],
            ['Minister name', 'November', 'People', 'Purpose'],
            ['Minister name', 'December', 'People', 'Purpose'],
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': None, 'Month': 1, 'Day': None}, normalised[0][1])
        self.assertEqual({'Year': None, 'Month': 2, 'Day': None}, normalised[1][1])
        self.assertEqual({'Year': None, 'Month': 3, 'Day': None}, normalised[2][1])
        self.assertEqual({'Year': None, 'Month': 4, 'Day': None}, normalised[3][1])
        self.assertEqual({'Year': None, 'Month': 5, 'Day': None}, normalised[4][1])
        self.assertEqual({'Year': None, 'Month': 6, 'Day': None}, normalised[5][1])
        self.assertEqual({'Year': None, 'Month': 7, 'Day': None}, normalised[6][1])
        self.assertEqual({'Year': None, 'Month': 8, 'Day': None}, normalised[7][1])
        self.assertEqual({'Year': None, 'Month': 9, 'Day': None}, normalised[8][1])
        self.assertEqual({'Year': None, 'Month': 10, 'Day': None}, normalised[9][1])
        self.assertEqual({'Year': None, 'Month': 11, 'Day': None}, normalised[10][1])
        self.assertEqual({'Year': None, 'Month': 12, 'Day': None}, normalised[11][1])

    def test_date_where_month_is_in_short_format(self):
        test_data = [
            ['Minister name', 'Jan', 'People', 'Purpose'],
            ['Minister name', 'Feb', 'People', 'Purpose'],
            ['Minister name', 'Mar', 'People', 'Purpose'],
            ['Minister name', 'Apr', 'People', 'Purpose'],
            ['Minister name', 'May', 'People', 'Purpose'],
            ['Minister name', 'Jun', 'People', 'Purpose'],
            ['Minister name', 'Jul', 'People', 'Purpose'],
            ['Minister name', 'Aug', 'People', 'Purpose'],
            ['Minister name', 'Sep', 'People', 'Purpose'],
            ['Minister name', 'Oct', 'People', 'Purpose'],
            ['Minister name', 'Nov', 'People', 'Purpose'],
            ['Minister name', 'Dec', 'People', 'Purpose'],
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': None, 'Month': 1, 'Day': None}, normalised[0][1])
        self.assertEqual({'Year': None, 'Month': 2, 'Day': None}, normalised[1][1])
        self.assertEqual({'Year': None, 'Month': 3, 'Day': None}, normalised[2][1])
        self.assertEqual({'Year': None, 'Month': 4, 'Day': None}, normalised[3][1])
        self.assertEqual({'Year': None, 'Month': 5, 'Day': None}, normalised[4][1])
        self.assertEqual({'Year': None, 'Month': 6, 'Day': None}, normalised[5][1])
        self.assertEqual({'Year': None, 'Month': 7, 'Day': None}, normalised[6][1])
        self.assertEqual({'Year': None, 'Month': 8, 'Day': None}, normalised[7][1])
        self.assertEqual({'Year': None, 'Month': 9, 'Day': None}, normalised[8][1])
        self.assertEqual({'Year': None, 'Month': 10, 'Day': None}, normalised[9][1])
        self.assertEqual({'Year': None, 'Month': 11, 'Day': None}, normalised[10][1])
        self.assertEqual({'Year': None, 'Month': 12, 'Day': None}, normalised[11][1])

    def test_date_where_month_is_sept(self):
        test_data = [
            ['Minister name', 'Sept', 'People', 'Purpose']
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': None, 'Month': 9, 'Day': None}, normalised[0][1])

    def test_date_where_there_is_no_month_and_day(self):

        test_data = [
            ['Minister name', '2011', 'People', 'Purpose']
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': 2011, 'Month': None, 'Day': None}, normalised[0][1])

    def test_date_when_there_is_no_date_info(self):

        test_data = [
            ['Minister name', '', 'People', 'Purpose']
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': None, 'Month': None, 'Day': None}, normalised[0][1])

    def test_date_with_year_month_day(self):
        #date has to be in format day month year
        test_data = [
            ['Minister name', '13 January 2012', 'People', 'Purpose']
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': 2012, 'Month': 1, 'Day': 13}, normalised[0][1])

    def test_date_with_abbreviated_month_with_day_and_year(self):

        test_data = [
            ['Minister name', '13 Jan 2012', 'People', 'Purpose']
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': 2012, 'Month': 1, 'Day': 13}, normalised[0][1])

    def test_date_with_abbreviated_month_and_day(self):

        test_data = [
            # ['Minister name', '3 2012', 'People', 'Purpose'] assuming this is unlikely to be the date
            ['Minister name', '3 Jan', 'People', 'Purpose']
        ]

        normalised = normalise(test_data)

        self.assertEqual({'Year': None, 'Month': 1, 'Day': 3}, normalised[0][1])

class ExtractInfoFromFilenameTestCase(unittest.TestCase):

    def test_title_with_1_key_string_returns_string_as_type(self):
        KEY_STRINGS = ['key1', 'key2']
        title = 'icontainkey1butnotkey-2.csv'
        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual('key1', info['type'])

    def test_title_with_0_key_strings_raises_TypeNotFoundException(self):
        KEY_STRINGS = ['key1', 'key2']
        title = 'idonotcontainkey-1orkey-2.csv'

        with self.assertRaises(TypeNotFoundException):
            extract_info_from_filename(title, type_strings=KEY_STRINGS)

    def test_title_with_2_key_strings_raises_MultipleTypesFoundException(self):
        KEY_STRINGS = ['key1', 'key2']
        title = 'icontainbothkey1andkey2.csv'

        with self.assertRaises(MultipleTypesFoundException) as mtfe:
            extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertIn('key1', mtfe.exception.type_keys)
        self.assertIn('key2', mtfe.exception.type_keys)

    def test_title_with_no_year_string_returns_None_as_date(self):
        KEY_STRINGS = ['key1', 'key2']
        title = 'icontainkey1butnoyear.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(None, info['year'])

    def test_title_with_a_two_digit_year_returns_them_plus_2000_as_year(self):
        KEY_STRINGS = ['key1', 'key2']
        title = 'icontainkey1from07.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(2007, info['year'])

        title = '15istheyearkey1isthetype.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(2015, info['year'])

    def test_title_with_a_four_digit_year_returns_them_as_year(self):
        KEY_STRINGS = ['key1', 'key2']
        title = 'icontainkey1from2016.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(2016, info['year'])

        title = '2010istheyearkey1isthetype.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(2010, info['year'])

    def test_title_with_multiple_year_strings_returns_None_as_date(self):
        KEY_STRINGS = ['key1', 'key2']
        title = 'icontainkey1andyears12and14.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(None, info['year'])

        title = 'icontainkey1andyears2012and2014.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(None, info['year'])

        title = 'icontainkey1andyears2012and14.csv'

        info = extract_info_from_filename(title, type_strings=KEY_STRINGS)

        self.assertEqual(None, info['year'])
