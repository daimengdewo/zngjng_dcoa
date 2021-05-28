from django.urls import path
 
from . import views
 
urlpatterns = [
    path('signin', views.signin),
    path('signout',views.signout),
    path('adduser',views.adduser),
    path('deluser',views.deluser),
    path('getlist',views.getlist),
    path('gettotal',views.getlist_total),
    path('reactive',views.re_user_active),
    path('repass',views.re_user_pass),
]