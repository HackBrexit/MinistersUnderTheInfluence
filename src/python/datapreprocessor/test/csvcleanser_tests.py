import unittest
import datapreprocessor
from datapreprocessor.csvcleanser import cleanse_csv_data

class CsvCleanserTest(unittest.TestCase):

    def test_should_remove_all_blank_lines(self):
        a_meeting = [
            'Government Whip (Lords), Lord Wallace of Saltaire',
            'May',
            'London School of Economics',
            'Discussion around WW1 commemoration']

        a_blank_line = ['', '', '', '']

        test_csv_data = [
            a_blank_line,
            a_meeting,
            a_blank_line,
            a_blank_line,
            a_meeting
        ]

        cleansed_data = cleanse_csv_data(test_csv_data)

        self.assertEqual(2, len(cleansed_data))
        self.assertEqual(a_meeting, cleansed_data[0])
        self.assertEqual(a_meeting, cleansed_data[1])

    def test_should_remove_additional_columns(self):
        test_csv_data = [
            ['Some minister', 'A date', 'Invitees', 'Meeting purpose'],
            ['Some minister', 'A date', 'Invitees', 'Meeting purpose', '', '', '', ''],
            ['Some minister', 'A date', 'Invitees', 'Meeting purpose', '', '', ''],
            ['Some minister', 'A date', 'Invitees', 'Meeting purpose', '', ''],
            ['Some minister', 'A date', 'Invitees', 'Meeting purpose', '', '', '', 'random superfluous data'],
        ]

        cleansed_data = cleanse_csv_data(test_csv_data)

        for item in cleansed_data:
            self.assertEqual(['Some minister', 'A date', 'Invitees', 'Meeting purpose'], item)

    def test_should_remove_boilerplate_lines(self):
        test_csv_data = [
            ['Minister', 'Date', 'Name of External Organisation', 'Purpose of meeting'],
            ['Minister', 'Date', 'Name of Organisation', 'Purpose of meeting'],
            ['Does not normally include meetings with Government bodies such as other Government Departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of devolved or foreign governments', '', '', ''],
            ['Note', '', '', ''],
            ['Does not normally include meetings with Government bodies such as other Government departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of Parliament, devolved or foreign governments.', '', '', '']
        ]

        cleansed_data = cleanse_csv_data(test_csv_data)

        self.assertEqual(0, len(cleansed_data))
