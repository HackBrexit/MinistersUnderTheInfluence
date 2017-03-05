from entity import Entity, EntityData
from meetingapiclient import MeetingApiClient

class PersonData(EntityData):
    def __init__(self, name, wikipedia_url):
        EntityData.__init__(self, 'people', name, wikipedia_url)

class Person(Entity):
    def __init__(self, entity_data, id, url):
        Entity.__init__(self, 'people', entity_data, id, url)


class PersonClient(MeetingApiClient):
    def __init__(self, base_url):
        MeetingApiClient.__init__(self, base_url, 'people')

    def build_entity(self, data, id, entity_url):
        return Person(data, id, entity_url)


if __name__ == '__main__':
    client = PersonClient('http://localhost:3000/api/v1/')
    mp = 'The Rt Hon Andrew Lansley MP'

    # Get person from meetings api (this will work if the db is seeded - run `rails db:seed && rails s`)
    person = client.get_by_name(mp)
    print person

    # Add person to api
    new_person = PersonData('Jo Osborne', None)
    added = client.add(new_person)
    print added

    # Delete person from api
    client.delete(added)
