#!/usr/bin/env bash

. /opt/venv/bin/activate
cd simple_web_app
gunicorn simple_web_app.wsgi:application --bind 0.0.0.0:8080
