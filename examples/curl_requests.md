## curl request examples

### card requests

INDEX
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/cards"

CREATE
    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"card":{"reference":"Rom 3:23","scripture":"For all have sinned yep"}}' http://localhost:3000/api/cards

DELETE
    curl -i -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://localhost:3000/api/cards/1

EDIT
    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"card":{"reference":"Rom 6:23","scripture":"For the wages of sin is death"}}' http://localhost:3000/api/cards/1

### category requests

INDEX
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categories"

CREATE
    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"category":{"name":"equipped disciple"}}' http://localhost:3000/api/categories

DELETE
    curl -i -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -X DELETE http://localhost:3000/api/categories/1

EDIT
    curl -v -H "Accept: application/smapi.v1+json" -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"category":{"name":"balloons"}}' http://localhost:3000/api/categories/1

### categorization requests

INDEX
    curl -H "Accept: application/smapi.v1+json" "localhost:3000/api/categorizations"
