#!/bin/ash
npm start > ./service.log &

tail -f ./service.log