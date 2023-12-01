from django.urls import path
from book_rec import views as bookrec_view

app_name = "book_rec"

urlpatterns = [    
    path('api/bookrec_bookbased/<int:book_id>/', bookrec_view.Book_Based_Rec_APIView.as_view(), name="bookrec_bookbased"),
    path('api/bookrec_userbased/<int:user_id>/', bookrec_view.User_Based_Rec_APIView.as_view(), name="bookrec_userbased"),
    path('api/book_rating/<int:book_id>/', bookrec_view.Book_Rating_APIView.as_view(), name="book_rating")
]