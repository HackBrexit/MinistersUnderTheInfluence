import unittest
import requests
import os
from datapreprocessor.personclient import PersonClient

INTEGRATION_TESTS = os.environ.get('INTEGRATION_TESTS', False)

@unittest.skipUnless(INTEGRATION_TESTS, 'api integration tests')
class PersonClientTest(unittest.TestCase):

    def test_person_lifecycle(self):
        """This test verifies that a person can be created, retrieved and deleted"""
        person_name = "Freddy the Frog"
        client = Client('http://localhost:3000/api/v1/')

        # Initial Retrieve (when person does not exist)
        no_person = client.get_by_name(person_name)
        self.assertEqual(None, no_person)

        # Create person
        create_response = client.add(person_name)
        self.assertEqual(requests.codes.created, create_response.status_code)

        # Retrieve person
        person = client.get_by_name(person_name)
        self.assertEqual(person_name, person['attributes']['name'])

        # Delete person
        delete_response = client.delete(person_name)
        self.assertEqual(requests.codes.no_content, delete_response.status_code)
