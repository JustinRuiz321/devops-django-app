# greetings/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.show_greeting, name='show_greeting'),
]