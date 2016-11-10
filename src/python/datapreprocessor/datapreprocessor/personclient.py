import requests
import json


class ApiException(Exception):
    pass


class BadRequest(ApiException):
    pass


class EntityData():
    def __init__(self, name, wikipedia_url):
        self.name = name
        self.wiki = wikipedia_url

    def to_json(self):
        return json.dumps({
            'data': {
                'type': 'people',
                'attributes': {
                    'name': self.name,
                    'wikipedia-entry': self.wiki
                }
            }
        })


class Person():
    def __init__(self, entity_data, id, self_link):
        self.entity_data = entity_data
        self.id = id
        self.link = self_link


class PersonClient():
    def __init__(self, base_url):
        self.entity_type = 'people'
        self.url = base_url + self.entity_type # todo check url has trailing forward slash
        self.headers = {'content-type': 'application/vnd.api+json; charset=utf-8'}


    def handle_api_error(self, status_code):
        # todo - handle properly
        if status_code == 400:
            raise BadRequest()
        else:
            print status_code


    def build_person_from_response(self, content):
        data = EntityData(content['attributes']['name'], content['attributes']['wikipedia-entry'])
        id = content['id']
        self_link = content['links']['self']
        return Person(data, id, self_link)


    def _get(self, url):
        response = requests.get(url, headers = self.headers)
        if response.status_code == requests.codes.ok:
            content = response.json()['data'] #[0] # todo check if this is empty first
            if len(content) > 0:
                return self.build_person_from_response(content[0])
            else:
                return None
        else:
            self.handle_api_error(response.status_code)


    def _post(self, url, data):
        response = requests.post(url, data = data.to_json(), headers = self.headers)
        if response.status_code == requests.codes.created:
            content = response.json()['data']
            return self.build_person_from_response(content)
        else:
            self.handle_api_error(response.status_code)


    def _delete(self, url):
        response = requests.delete(url, headers = self.headers)
        if response.status_code != requests.codes.no_content:
            self.handle_api_error(response.status_code)


    def get_by_name(self, name):
        """Return a Person if one exists with this name, or None if none are found. Throws ApiException"""
        url = self.url + '/' + '?filter[name]=' + name
        return self._get(url)


    def add(self, data):
        """If person exists, retrieve and return them. Otherwise, create and return person. Throws ApiException"""
        person = self.get_by_name(data.name)
        if person:
            return person
        else:
            return self._post(self.url, data)


    def delete(self, person):
        """Delete person. Return nothing. Throws ApiException"""
        return self._delete(person.link)


if __name__ == '__main__':
    client = PersonClient('http://localhost:3000/api/v1/')
    mp = 'The Rt Hon Andrew Lansley MP'
    person = client.get_by_name(mp)
    print person

    new_person = EntityData('Jo Osborne', None)
    added = client.add(new_person)
    print added

    client.delete(added)
