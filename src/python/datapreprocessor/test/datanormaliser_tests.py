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
