# Elasticsearch

For now, all we have is some rough notes on the experiments we did
during the Hack Day on 5th March 2017.

## Details of experiments

This is what we tried:

- Install elasticsearch

- `/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head`

- Go to http://localhost:9200/_plugin/head/

- Click on the `Any Request` tab

- Create an index `muti` with settings by submitting the following
  "query" (API request):

    - POST http://localhost:9200/muti

            {
              "analysis": {
                "char_filter": {
                  "&_to_and": {
                    "type": "mapping",
                    "mappings": [
                      "&=> and "
                    ]
                  }
                },
                "filter": {
                  "filter_stop": {
                    "type": "stop"
                  },
                  "filter_shingle": {
                    "type": "shingle",
                    "max_shingle_size": 5,
                    "min_shingle_size": 2,
                    "output_unigrams": "true"
                  }
                },
                "analyzer": {
                  "analyzer_shingle": {
                    "type": "custom",
                    "char_filter": [
                      "html_strip",
                      "&_to_and"
                    ],
                    "tokenizer": "standard",
                    "filter": [
                      "standard",
                      "lowercase",
                      "filter_stop",
                      "filter_shingle"
                    ]
                  }
                }
              }
            }

- Create types for the `muti` index

    - PUT http://localhost:9200/muti/meetings/_mapping

            {
              "properties": {
                "meetingId": {
                  "index": "not_analyzed",
                  "type": "string"
                },
                "minister": {
                  "analyzer": "analyzer_shingle",
                  "type": "string"
                },
                "department": {
                  "analyzer": "analyzer_shingle",
                  "type": "string"
                },
                "organization": {
                  "analyzer": "analyzer_shingle",
                  "type": "string"
                },
                "reason": {
                  "analyzer": "analyzer_shingle",
                  "type": "string"
                }
              }
            }

- Index documents

    - POST http://localhost:9200/muti/meetings where the body takes
      this format:

            {
              "meetingId" : meeting_ref,
              "minister" : minister,
              "department" : department,
              "organization" : org,
              "reason" : reason,
            }

      See https://github.com/aspiers/MinistersUnderTheInfluence/releases/tag/elasticsearch-push-2017-03-05
      for code which we successfully used to do this.

- Try an unfiltered search with aggregations

    - POST http://localhost:9200/muti/meetings/_search

            {
                "from": 0,
                "query": {
                    "match_all": {}
                },
                "aggs": {
                    "organization": {
                        "terms": {
                            "field": "organization"
                        }
                    },
                    "ministers": {
                        "terms": {
                            "field": "minister"
                        }
                    }
                }
            }
