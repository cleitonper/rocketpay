#!/bin/sh

dockerize -wait tcp://$DB_HOSTNAME:$DB_PORT -timeout 40s

bin/rocketpay eval "Rocketpay.Release.migrate"
bin/rocketpay start