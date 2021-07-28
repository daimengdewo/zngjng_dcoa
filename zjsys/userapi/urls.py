from django.urls import path
 
from .import views

urlpatterns = [
    path('dispat', views.dispatcher),
    path('netpass', views.face_netpass),
]