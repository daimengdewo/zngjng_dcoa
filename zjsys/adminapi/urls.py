from django.urls import path
 
from . import views
from common.views import dispatcher
 
urlpatterns = [
    path('signin', views.signin),
    path('signout',views.signout),
    path('dispat', dispatcher),
    path('adduser',views.adduser),
    path('deluser',views.deluser),
    path('getlist',views.getlist),
    path('gettotal',views.getlist_total),
    path('reactive',views.re_user_active),
]