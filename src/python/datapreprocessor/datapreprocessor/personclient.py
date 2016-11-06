import requests
import json
from ipersonclient import IPersonClient

class PersonClient(IPersonClient):
    def get_all(self):
        response = self._get(self._build_url('people'))
        items = response.json()['data']
        return items


    def get_by_name(self, person_name):
        people = self.get_people()
        person = filter((lambda p: p['attributes']['name'] == person_name), people)
        if person:
            return person[0]
        else:
            return None


    def add(self, person_name):
        if self.get_person(person_name):
            return None
        else:
            data = {'data': {'type': 'people', 'attributes': {'name': person_name}}}
            response = self._post(self._build_url('people'), data)
            return response


    def delete(self, person_name):
        person = self.get_person(person_name)
        if person:
            return self._delete(person['links']['self'])
        else:
            return None
