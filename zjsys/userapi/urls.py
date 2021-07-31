from django.urls import path
 
from .import views

urlpatterns = [
    path('newface', views.newface),
    path('delface', views.delface),
    path('clock', views.clock),
    path('qjset', views.qjset),
]