## curl request examples

### card requests

INDEX

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/cards" -i
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/cards?last_updated=2013-05-05" -i

CREATE

    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"card":{"reference":"Rom 3:23","scripture":"For all have sinned yep"}}' http://localhost:3000/api/cards -i

DELETE

    curl -i -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://localhost:3000/api/cards/1 -i

EDIT

    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"card":{"reference":"Rom 6:23","scripture":"For the wages of sin is death"}}' http://localhost:3000/api/cards/1 -i

### category requests

INDEX

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categories" -i
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categories?last_updated=2013-05-07" -i

CREATE

    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"category":{"name":"equipped disciple"}}' http://localhost:3000/api/categories -i

DELETE

    curl -i -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://localhost:3000/api/categories/1 -i

EDIT

    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"category":{"name":"balloons"}}' http://localhost:3000/api/categories/1 -i

### categorization requests

INDEX

    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categorizations" -i
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categorizations?last_updated=2013-05-07" -i
