from entity import Entity, EntityData
from meetingapiclient import MeetingApiClient

class OrganisationData(EntityData):
    def __init__(self, name, wikipedia_url):
        EntityData.__init__(self, 'organisations', name, wikipedia_url)

class Organisation(Entity):
    def __init__(self, entity_data, id, url):
        Entity.__init__(self, 'organisations', entity_data, id, url)


class OrganisationClient(MeetingApiClient):
    def __init__(self, base_url):
        MeetingApiClient.__init__(self, base_url, 'organisations')

    def build_entity(self, data, id, entity_url):
        return Organisation(data, id, entity_url)


if __name__ == '__main__':
    client = OrganisationClient('http://localhost:3000/api/v1/')
    org = ""

    # Get organisaion from meetings api (this will work if the db is seeded - run `rails db:seed && rails s`)
    print client.get_by_name(org)

    # Add organisaion to api
    new_org = OrganisationData('My Inc', None)
    added = client.add(new_org)
    print added

    # Delete organisaion from api
    client.delete(added)
