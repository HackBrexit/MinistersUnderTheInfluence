#!/usr/bin/env python

import csv
import requests

IMPORT_FILE_PATH = './BAE Data.csv'
FROM_ID = 39
TO_ID = 50


BASE_API_URL = 'http://en.staging.meetings.vidhya.tv/api/v1'


CACHE = {
    'government-offices': {},
    'meetings': {},
    'organisations': {},
    'people': {},
}


def post_to_api_and_return_id(endpoint, data):
    url = '{0}/{1}'.format(BASE_API_URL, endpoint)
    resp = requests.post(url, json=data, headers={'Content-Type': 'application/vnd.api+json'})
    resp_data = resp.json()
    if 'data' not in resp_data or not resp_data['data']:
        return None
    return resp_data["data"]["id"]


def lookup_from_api(endpoint, name):
    url = '{0}/{1}?filter[name]={2}'.format(BASE_API_URL, endpoint, name)
    resp = requests.get(url)
    data = resp.json()['data']
    if not data:
        return None
    return data[0]["id"]


def create_minister_link(meeting_id, minister_id, department_id):
    type_ = "influence-government-office-people"
    req_data = {
        "data": {
            "type": type_,
            "relationships": {
                "meeting": {
                    "data": {
                        "type": "meetings",
                        "id": meeting_id
                    }
                },
                "government-office": {
                    "data": {
                        "type": "government-offices",
                        "id": department_id
                     }
                },
                "person": {
                     "data": {
                        "type": "people",
                        "id": minister_id
                     }
                }
            }
        }
    }
    return post_to_api_and_return_id(type_, req_data)


def create_rep_link(meeting_id, rep_id, organisation_id):
    type_ = "influence-organisation-people"
    req_data = {
        "data": {
            "type": type_,
            "relationships": {
                "meeting": {
                    "data": {
                        "type": "meetings",
                        "id": meeting_id
                    }
                },
                "organisation": {
                    "data": {
                        "type": "organisations",
                        "id": organisation_id
                     }
                },
                "person": {
                     "data": {
                        "type": "people",
                        "id": rep_id
                     }
                }
            }
        }
    }
    return post_to_api_and_return_id(type_, req_data)


def get_or_create_meeting_id(meeting_ref, date_, reason):
    if meeting_ref in CACHE['meetings']:
        return CACHE['meetings'][meeting_ref]
    req_data = {
        "data": {
            "type": "meetings",
            "attributes": {
                "purpose": reason,
            }
        }
    }
    date_parts = date_.split('-')
    if len(date_parts) > 0:
        req_data['data']['attributes']['year'] = date_parts[0]
    if len(date_parts) > 1:
        req_data['data']['attributes']['month'] = date_parts[1]
    if len(date_parts) > 2:
        req_data['data']['attributes']['day'] = date_parts[2]
    CACHE['meetings'][meeting_ref] = post_to_api_and_return_id('meetings', req_data)
    return CACHE['meetings'][meeting_ref]


def get_or_create_department_id(department):
    return get_or_create_entity_id('government-offices', department)


def get_or_create_person_id(name):
    return get_or_create_entity_id('people', name)


def get_or_create_organisation_id(name):
    return get_or_create_entity_id('organisations', name)


def get_or_create_entity_id(type_, name):
    if name in CACHE[type_]:
        return CACHE[type_][name]
    entity_id = lookup_from_api(type_, name)
    if entity_id:
        CACHE[type_][name] = entity_id
        return CACHE[type_][name]
    req_data = {
        "data": {
            "type": type_,
            "attributes": {
                "name": name,
            }
        }
    }
    CACHE[type_][name] = post_to_api_and_return_id(type_, req_data)
    return CACHE[type_][name]


def main():
    with open(IMPORT_FILE_PATH, 'rU') as fh:
        reader = csv.reader(fh)
        skip = True
        for row in reader:
            if skip:
                skip = False
                continue
            if int(row[0]) < FROM_ID or int(row[0]) > TO_ID:
                continue
            meeting_ref = row[0]
            minister = row[1]
            department = row[3]
            date_ = row[4]
            org = row[6]
            rep = row[7]
            reason = row[8]
            meeting_id = get_or_create_meeting_id(meeting_ref, date_, reason)
            department_id = get_or_create_department_id(department)
            minister_id = get_or_create_person_id(minister)
            organisation_id = get_or_create_organisation_id(org)
            rep_id = get_or_create_person_id(rep or 'Representative from {0}'.format(org))
            create_minister_link(meeting_id, minister_id, department_id)
            create_rep_link(meeting_id, rep_id, organisation_id)
    

if __name__ == '__main__':
    main()
