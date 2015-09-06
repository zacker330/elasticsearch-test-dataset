#!/bin/bash
if [ ! -n "$ES_TEST_HOST" ] ; then
  export ES_TEST_HOST="http://localhost:9200"
  echo -e "set ES_TEST_HOST = http://localhost:9200\n"
fi

echo -e "delete people index"
curl -X DELETE "$ES_TEST_HOST/people"

echo -e "\ncreate people index"
curl -X PUT -d '{
    "settings":{
        "index":{
            "number_of_shards":1,
            "number_of_replicas": 1
        }
    }
}' "$ES_TEST_HOST/people/"

echo -e "\ncreate chinese_people mapping in people index"
curl -X PUT  -d '{
        "chinese_people": {
            "_source": {"enabled": true},
            "properties":{
                "country": {
                  "type": "string"
                },
                "deposit": {
                  "type": "float"
                },
                "email": {
                  "type": "string"
                },
                "first_name": {
                  "type": "string"
                },
                "id": {
                  "type": "long"
                },
                "ip_address": {
                  "type": "string"
                },
                "last_name": {
                  "type": "string"
                }
            }

        }
}
' "$ES_TEST_HOST/people/_mapping/chinese_people"


echo -e "\npush test dataset"

curl -X POST "$ES_TEST_HOST/_bulk" --data-binary @./chinses_people_test_data.json &>/dev/null
