#!/bin/bash
set -e

echo "Running database migrations..."
python manage.py migrate

echo "Seeding greetings..."
python manage.py shell -c 'from greetings.models import Greeting; Greeting.objects.get_or_create(message="Hello from the containerized DB!")'

echo "Starting Django server..."
exec python manage.py runserver 0.0.0.0:8000

echo "Startup DJANGO_ALLOWED_HOSTS: $DJANGO_ALLOWED_HOSTS"