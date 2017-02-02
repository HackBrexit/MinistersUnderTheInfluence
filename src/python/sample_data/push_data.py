#!/usr/bin/env python
"""
Script to push a cleaned data file to the MUTI API
Requires a python environment with `requests` available in it.
There's currently nothing preventing things from being added again if you run
 the script more than once over the same meeting ids
Meeting ids only have to be unique within the file currently being pushed.
"""

import csv
import json
import requests
import simplejson

from argparse import ArgumentParser


BASE_API_URL = 'http://localhost:3000/api/v1'


CACHE = {
    'source-files': {},
    'government-offices': {},
    'meetings': {},
    'organisations': {},
    'people': {},
}


def pprint_json(json_data):
    print(json.dumps(json_data, sort_keys=True,
                     indent = 4, separators=(',', ': ')))

def post_to_api_and_return_id(endpoint, data):
    url = '{0}/{1}'.format(BASE_API_URL, endpoint)
    resp = requests.post(url, json=data, headers={'Content-Type': 'application/vnd.api+json'})

    if not resp.ok:
        print("POST %s failed:\n%d %s" % (url, resp.status_code, resp.reason))
        print("Request was:")
        pprint_json(data)

    try:
        resp_data = resp.json()
    except simplejson.scanner.JSONDecodeError:
        resp_data = None

    if not resp.ok:
        print("Response was:")
        if resp_data is None:
            print(resp.text)
        else:
            pprint_json(resp_data)

        resp.raise_for_status()

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
            }
        }
    }
    if minister_id is not None:
        req_data["data"]["relationships"]["person"] = {
            "data": {
                "type": "people",
                "id": minister_id
            }
        }
    if department_id is not None:
        req_data["data"]["relationships"]["government-office"] = {
            "data": {
                "type": "government-offices",
                "id": department_id
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
                "person": {
                    "data": {
                        "type": "people",
                        "id": rep_id
                    }
                }
            }
        }
    }
    if organisation_id is not None:
        req_data["data"]["relationships"]["organisation"] = {
            "data": {
                "type": "organisations",
                "id": organisation_id
            }
        }
    return post_to_api_and_return_id(type_, req_data)


def get_or_create_meeting_id(meeting_ref, date_, reason, source_id, line_num):
    if meeting_ref in CACHE['meetings']:
        return CACHE['meetings'][meeting_ref]
    req_data = {
        "data": {
            "type": "meetings",
            "attributes": {
                "source-file-id" : source_id,
                "source-file-line-number" : line_num,
            }
        }
    }
    if reason != "":
        req_data["data"]["attributes"]["purpose"] = reason

    date_parts = date_.split('-')
    if len(date_parts) > 0:
        req_data['data']['attributes']['year'] = date_parts[0]
    if len(date_parts) > 1:
        req_data['data']['attributes']['month'] = date_parts[1]
    if len(date_parts) > 2:
        req_data['data']['attributes']['day'] = date_parts[2]
    CACHE['meetings'][meeting_ref] = post_to_api_and_return_id('meetings', req_data)
    return CACHE['meetings'][meeting_ref]


def get_or_create_source_id(filename):
    if filename in CACHE['source-files']:
        return CACHE['source-files'][filename]
    req_data = {
        "data": {
            "type": "source-files",
            "attributes": {
                "location" : filename,
                "uri" : "file://%s" % filename,
            }
        }
    }
    CACHE['source-files'][filename] = post_to_api_and_return_id('source-files', req_data)
    return CACHE['source-files'][filename]


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
    global BASE_API_URL
    parser = ArgumentParser()
    parser.add_argument("file", help="Push data from FILE", metavar="FILE")
    parser.add_argument("--from-id", dest="from_id", type=int, default=0, metavar="FROM_ID",
                        help="Ignore rows with meeting id < FROM_ID")
    parser.add_argument("--to-id", dest="to_id", type=int, default=1000000, metavar="TO_ID",
                        help="Ignore rows with meeting id > TO_ID")
    parser.add_argument("--api-base", dest="base_api_url",
                        default=BASE_API_URL, metavar="BASE_API_URL",
                        help="Push data to api at BASE_API_URL")
    args = parser.parse_args()
    BASE_API_URL = args.base_api_url
    print("Reading from %s, min id: %d, max id: %d" %
          (args.file, args.from_id, args.to_id))

    count = 0
    with open(args.file, 'rU') as fh:
        reader = csv.reader(fh)
        skip = True
        for row in reader:
            if skip:
                skip = False
                continue
            try:
                meeting_ref = int(row[0])
            except ValueError:
                print("Couldn't parse meeting id; ignoring row:")
                print(row)
                continue
            if int(meeting_ref) < args.from_id or int(meeting_ref) > args.to_id:
                continue
            print(row)
            minister = row[1]
            role = row[2] # FIXME: not used yet
            department = row[3]
            date_ = row[4]
            org = row[6]
            rep = row[7]
            reason = row[8]
            source_id = get_or_create_source_id(args.file)
            meeting_id = get_or_create_meeting_id(meeting_ref, date_, reason, source_id, reader.line_num)
            department_id = get_or_create_department_id(department) if department != "" else None
            minister_id = get_or_create_person_id(minister) if minister != "" else None
            organisation_id = get_or_create_organisation_id(org) if org != "" else None
            rep_id = get_or_create_person_id(rep or 'Representative from {0}'.format(org))
            create_minister_link(meeting_id, minister_id, department_id)
            create_rep_link(meeting_id, rep_id, organisation_id)
            count += 1

    print("%d rows processed" % count)


if __name__ == '__main__':
    main()
