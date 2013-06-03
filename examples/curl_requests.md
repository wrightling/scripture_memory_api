## curl request examples

### card requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/cards/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/cards" -i
    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/cards?last_updated=2013-05-05" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"cards":[{"reference":"Rom 3:23","scripture":"For all have sinned and fall short of the glory of God.","translation":"NASB"}]}' http://smapi.herokuapp.com/api/cards -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://smapi.herokuapp.com/api/cards/1 -i

EDIT

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PATCH -d '{"cards":[{"reference":"Rom 6:23","scripture":"For the wages of sin is death"}]}' http://smapi.herokuapp.com/api/cards/1 -i

### category requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/categories/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/categories" -i
    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/categories?last_updated=2013-05-07" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"categories":[{"name":"equipped disciple"}]}' http://smapi.herokuapp.com/api/categories -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://smapi.herokuapp.com/api/categories/1 -i

EDIT

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PATCH -d '{"categories":[{"name":"balloons"}]}' http://smapi.herokuapp.com/api/categories/1 -i

### categorization requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/categorizations/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/categorizations" -i
    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/categorizations?last_updated=2013-05-07" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"categorizations":[{"card_id":"1","category_id":"1"}]}' http://smapi.herokuapp.com/api/categorizations -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://smapi.herokuapp.com/api/categorizations/1 -i

### collection requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/collections/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/collections" -i
    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/collections?last_updated=2013-05-07" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"collections":[{"name":"summer bible study"}]}' http://smapi.herokuapp.com/api/collections -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://smapi.herokuapp.com/api/collections/1 -i

EDIT

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PATCH -d '{"collections":[{"name":"equipped disciple class"}]}' http://smapi.herokuapp.com/api/collections/1 -i

### collectionship requests

SHOW

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/collectionships/1" -i

INDEX

    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/collectionships" -i
    curl -H "Accept: application/smapi.v1+json" "smapi.herokuapp.com/api/collectionships?last_updated=2013-05-07" -i

CREATE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"collectionships":[{"card_id":"1","collection_id":"1"}]}' http://smapi.herokuapp.com/api/collectionships -i

DELETE

    curl -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://smapi.herokuapp.com/api/collectionships/1 -i
