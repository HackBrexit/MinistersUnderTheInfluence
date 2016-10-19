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


    def test_should_remove_leading_and_trailing_whitespace_from_fields(self):
        test_data = [
            ['  Some minister', 'A date', 'Invitees', 'Meeting purpose'],
            ['Some minister        ', 'A date', 'Invitees', 'Meeting purpose'],
            ['Some minister', '   A date', 'Invitees', 'Meeting purpose'],
            ['Some minister', 'A date   ', 'Invitees', 'Meeting purpose'],
            ['Some minister', 'A date', '   Invitees', 'Meeting purpose'],
            ['Some minister', 'A date', 'Invitees    ', 'Meeting purpose'],
            ['Some minister', 'A date', 'Invitees', '   Meeting purpose'],
            ['Some minister', 'A date', 'Invitees', 'Meeting purpose    '],
        ]

        cleansed_data = cleanse_csv_data(test_data)

        for item in cleansed_data:
            self.assertEqual(['Some minister', 'A date', 'Invitees', 'Meeting purpose'], item)


    def test_should_remove_superscript_chars(self):
        # There are a lot of these /xb2 and /xb1 chars scattered through the csv files. We strip them out.
        test_data = [
                    ['Some minister', 'A date', 'Invitees', 'Meeting purpose\xb2'],
                    ['Some minister', 'A date', 'Invitees', 'Meeting purpose\xb1']
        ]

        cleansed_data = cleanse_csv_data(test_data)

        for item in cleansed_data:
            self.assertEqual(['Some minister', 'A date', 'Invitees', 'Meeting purpose'], item)


    def test_should_remove_boilerplate_lines(self):
        # These are all real examples from the sample files
        test_csv_data = [
            ['Minister', 'Date', 'Name of External Organisation', 'Purpose of meeting'],
            ['Minister', 'Date', 'Name of Organisation', 'Purpose of meeting'],
            ['Minister', 'Date', 'Name of Organisation', 'Purpose of meeting'],
            ['Minister', 'Date', 'Name of Organisation', 'Purpose of meeting\xb2'],
            ['Minister   ', 'Date', 'Name of External Organisation', 'Purpose of meeting'],
            ['\xb2Does not normally include meetings with Government bodies such as other Government Departments, members of the Royal Household, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of Parliament, devolved or foreign governments. Visits, attendance at seminars, conferences, receptions, media, interviews etc would not normally be classed as meetings', '', '', ''],
            ['Does not normally include attendance at functions hosted by HM Government; \x91diplomatic\x92 functions in the UK or abroad, hosted by overseas governments; minor refreshments at meetings, receptions, conferences, and seminars;  and offers of hospitality which were declined', '', '', ''],
            ['NOTE   Does not normally include meetings with Government bodies such as other Government Departments, NDPBs, Non - Ministerial Departments, Agencies, Government reviews and representatives of devolved or foreign governments', '', '', ''],
            ['Does not normally include meetings with Government bodies such as other Government Departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of devolved or foreign governments', '', '', ''],
            ['Note', '', '', ''],
            ['Does not normally include meetings with Government bodies such as other Government departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of Parliament, devolved or foreign governments.', '', '', ''],
            ['Does not normally include meetings with Government bodies such as other Government Departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of devolved or foreign governments.', '', '', ''],
            ['\xb2Does not normally include meetings with Government bodies such as other Government Departments, members of the Royal Household, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of Parliament, devolved or foreign governments.. Visits, attendance at seminars, conferences, receptions, media, interviews etc would not normally be classed as meetings', '', '', ''],
            ['Does not normally include meetings with Government bodies such as other Government Departments and Agencies, non-departmental public bodies, Government reviewers, and representatives of devolved or foreign governments.', '', '', ''],
            ['Does not normally include meetings with Government bodies such as other Government Departments, NDPBs, Non-Ministerial Departments, Agencies, Government reviews and representatives of Parliament, devolved or foreign governments.', '', '', '']
        ]

        cleansed_data = cleanse_csv_data(test_csv_data)

        self.assertEqual([], cleansed_data)
