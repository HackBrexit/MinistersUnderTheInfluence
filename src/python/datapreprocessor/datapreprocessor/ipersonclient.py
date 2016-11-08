from abc import ABCMeta, abstractmethod
import requests
import json

class IPersonClient:
    """This abstract client provides an interface for interacting with the meetings api to create, retrieve and
    delete people"""
    __metaclass__ = ABCMeta

    def __init__(self, url):
        self.url = url
        self.headers = {'content-type': 'application/vnd.api+json; charset=utf-8'}


    def _build_url(self, path):
        return self.url + path


    def _get(self, url):
        return requests.get(url, headers = self.headers)


    def _post(self, url, data):
        return requests.post(url, data = json.dumps(data), headers = self.headers)


    def _delete(self, url):
        return requests.delete(url, headers = self.headers)


    @abstractmethod
    def get_all(self):
        """Return a collection containing all people from the meetings api"""
        pass


    @abstractmethod
    def get_by_name(self, person_name):
        """Search for person by name. If they exist, return person else return None"""
        pass


    @abstractmethod
    def add(self, person_name):
        """Check if person with this name exists and if not, create them.
        Return http response, or None if person already exists."""
        pass


    @abstractmethod
    def delete(self, person):
        """If person exists, delete them. Return http response, or None if person does not exist"""
        pass
