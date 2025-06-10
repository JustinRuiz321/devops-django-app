from django.shortcuts import render
from greetings.models import Greeting

def show_greeting(request):
    print("Test")
    greeting = Greeting.objects.first()
    return render(request, "greetings/home.html", {"greeting": greeting})