from django.urls import path
 
from .import views

urlpatterns = [
    path('dispat', views.dispatcher),
]