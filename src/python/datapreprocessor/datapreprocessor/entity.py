import json

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


class Entity():
    def __init__(self, entity_type, entity_data, id, url):
        self.entity_type = entity_type
        self.entity_data = entity_data
        self.id = id
        self.url = url
