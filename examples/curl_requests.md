## curl request examples

### card requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/cards/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/cards" -i
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/cards?last_updated=2013-05-05" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"cards":[{"reference":"Rom 3:23","scripture":"For all have sinned and fall short of the glory of God.","translation":"NASB"}]}' http://localhost:3000/api/cards -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://localhost:3000/api/cards/1 -i

EDIT

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"cards":[{"reference":"Rom 6:23","scripture":"For the wages of sin is death"}]}' http://localhost:3000/api/cards/1 -i

### category requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categories/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categories" -i
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categories?last_updated=2013-05-07" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"categories":[{"name":"equipped disciple"}]}' http://localhost:3000/api/categories -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://localhost:3000/api/categories/1 -i

EDIT

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"categories":[{"name":"balloons"}]}' http://localhost:3000/api/categories/1 -i

### categorization requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categorizations/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categorizations" -i
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categorizations?last_updated=2013-05-07" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"categorizations":[{"card_id":"1","category_id":"1"}]}' http://localhost:3000/api/categorizations -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://localhost:3000/api/categorizations/1 -i
