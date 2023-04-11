from django.shortcuts import render, redirect
from .models import *


# Create your views here.

def create_book(request):
    if request.method == 'POST':
        title = request.POST['title']
        author = request.POST['author']
        content = request.POST['content']
        user = request.user  # get the currently logged-in user
        book = Book(title=title, author=author, content=content, user=user)
        book.save()
        return redirect('writer_page', book_id=book.id) # would i redirect to the writer page? 
    else:
        return render(request, 'create_book.html')

def create_chapter(request): # would i need to pass in the book id here?
    if request.method == 'POST':
        title = request.POST['title']
        content = request.POST['content']
        book = request.POST['book']
        chapter = Chapter(title=title, content=content, book=book)
        chapter.save()
    return render(request, 'books/create_chapter.html')

def create_character(request):
    if request.method == 'POST':
        name = request.POST['name']
        description = request.POST['description']
        book = request.POST['book']
        character = Character(name=name, description=description, book=book)
        character.save()
    return render(request, 'books/create_character.html')

def create_location(request):
    if request.method == 'POST':
        name = request.POST['name']
        description = request.POST['description']
        book = request.POST['book']
        location = Location(name=name, description=description, book=book)
        location.save()
    return render(request, 'books/create_location.html')

