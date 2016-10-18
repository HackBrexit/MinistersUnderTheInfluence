import unittest
from datapreprocessor.datanormaliser import normalise

class DataNormaliserTest(unittest.TestCase):

    def test_missing_minister_names_are_filled_in(self):
        minister_name = "Harry Potter"
        another_minister_name = "Frodo Baggins"

        test_data = [
            [minister_name, 'A date', 'An attendee', 'A purpose'],
            ['', 'A date', 'An attendee', 'A purpose'],
            ['', 'A date', 'An attendee', 'A purpose'],
            ['', 'A date', 'An attendee', 'A purpose'],
            [another_minister_name, 'A date', 'An attendee', 'A purpose'],
            ['', 'A date', 'An attendee', 'A purpose'],
        ]

        normalised = normalise(test_data)

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

        self.assertEqual('2011-01-XX', normalised[0][1])
        self.assertEqual('2011-02-XX', normalised[1][1])
        self.assertEqual('2011-03-XX', normalised[2][1])
        self.assertEqual('2011-04-XX', normalised[3][1])
        self.assertEqual('2011-05-XX', normalised[4][1])
        self.assertEqual('2011-06-XX', normalised[5][1])
        self.assertEqual('2011-07-XX', normalised[6][1])
        self.assertEqual('2011-08-XX', normalised[7][1])
        self.assertEqual('2011-09-XX', normalised[8][1])
        self.assertEqual('2011-10-XX', normalised[9][1])
        self.assertEqual('2011-11-XX', normalised[10][1])
        self.assertEqual('2011-12-XX', normalised[11][1])

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

        self.assertEqual('XXXX-01-XX', normalised[0][1])
        self.assertEqual('XXXX-02-XX', normalised[1][1])
        self.assertEqual('XXXX-03-XX', normalised[2][1])
        self.assertEqual('XXXX-04-XX', normalised[3][1])
        self.assertEqual('XXXX-05-XX', normalised[4][1])
        self.assertEqual('XXXX-06-XX', normalised[5][1])
        self.assertEqual('XXXX-07-XX', normalised[6][1])
        self.assertEqual('XXXX-08-XX', normalised[7][1])
        self.assertEqual('XXXX-09-XX', normalised[8][1])
        self.assertEqual('XXXX-10-XX', normalised[9][1])
        self.assertEqual('XXXX-11-XX', normalised[10][1])
        self.assertEqual('XXXX-12-XX', normalised[11][1])
