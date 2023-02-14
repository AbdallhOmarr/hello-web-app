from simple_web_app.settings import *
from decouple import config

SECRET_KEY = config('SECRET_KEY')
