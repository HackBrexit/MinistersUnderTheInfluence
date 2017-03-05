import requests
import apiexception
from entity import EntityData


class MeetingApiClient():
    def __init__(self, base_url, entity_type):
        self._entity_type = entity_type
        self._url = base_url + self._entity_type # todo check url has trailing forward slash
        self._headers = {'content-type': 'application/vnd.api+json; charset=utf-8'}


    def _handle_api_error(self, status_code):
        # todo - handle properly
        if status_code == 400:
            raise BadRequest()
        else:
            print status_code


    def build_entity(self, data, id, entity_url):
        """When subclassing to make specific clients, e.g PersonClient, overriding this method causes the client
        to return Person types rather than Entity types"""
        return Entity(self._entity_type, data, id, entity_url)


    def _build_entity_from_response(self, content):
        data = EntityData(self._entity_type, content['attributes']['name'], content['attributes']['wikipedia-entry'])
        id = content['id']
        entity_url = content['links']['self']
        return self.build_entity(data, id, entity_url)


    def _get(self, url):
        response = requests.get(url, headers = self._headers)
        if response.status_code == requests.codes.ok:
            content = response.json()['data']
            if len(content) > 0:
                return self._build_entity_from_response(content[0])
            else:
                return None
        else:
            self._handle_api_error(response.status_code)


    def _post(self, url, data):
        response = requests.post(url, data = data.to_json(), headers = self._headers)
        if response.status_code == requests.codes.created:
            content = response.json()['data']
            return self._build_entity_from_response(content)
        else:
            self._handle_api_error(response.status_code)


    def _delete(self, url):
        response = requests.delete(url, headers = self._headers)
        if response.status_code != requests.codes.no_content:
            self._handle_api_error(response.status_code)


    def get_by_name(self, name):
        """Return an entity if one exists with this name, or None if none are found. Throws ApiException"""
        url = self._url + '/' + '?filter[name]=' + name
        return self._get(url)


    def add(self, data):
        """If entity exists, retrieve and return it. Otherwise, create and return entity. Throws ApiException"""
        entity = self.get_by_name(data.name)
        if entity:
            return entity
        else:
            return self._post(self._url, data)


    def delete(self, entity):
        """Delete entity. Return nothing. Throws ApiException"""
        return self._delete(entity.url)
