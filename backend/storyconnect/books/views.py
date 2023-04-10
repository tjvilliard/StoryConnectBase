from django.shortcuts import render
from .models import *


# Create your views here.

def create_book(request):
    return render(request, 'books/create_book.html')

def create_chapter(request):
    return render(request, 'books/create_chapter.html')

def create_character(request):
    return render(request, 'books/create_character.html')

def create_location(request):
    return render(request, 'books/create_location.html')

