"""
Django settings for storyconnect project.

Generated by 'django-admin startproject' using Django 4.1.7.

For more information on this file, see
https://docs.djangoproject.com/en/4.1/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.1/ref/settings/
"""

from pathlib import Path
import os
import firebase_admin
from firebase_admin import storage
from firebase_admin import credentials
# from dotenv import load_dotenv

# load_dotenv()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-h0*oug9uh#y053hd0ij67=)fr@sytr5=fs_h5)dr_ft562%_8b'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ["storyconnect", "localhost", "127.0.0.1", "storyconnect.app"]

CSRF_TRUSTED_ORIGINS = [
    'https://storyconnect.app',
    'http://localhost:8000',
]

CSRF_COOKIE_DOMAIN = 'storyconnect.app'

# TODO: Change this to False when deploying to production
CORS_ALLOW_ALL_ORIGINS = True


# Application definition

INSTALLED_APPS = [
    'debug_toolbar',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'corsheaders',
    'django_filters',
    'django_extensions',
    'rest_framework',
    'rest_framework_json_api',
    'rest_framework.authtoken',
    'books',
    'comment',
    'core',
<<<<<<< HEAD


]

DEBUG_TOOLBAR_ENABLED = True

def show_toolbar(request):
    return True

DEBUG_TOOLBAR_CONFIG = {
    'INTERCEPT_REDIRECTS': False,
    'SHOW_TOOLBAR_CALLBACK': show_toolbar,
}

INTERNAL_IPS = [
    '127.0.0.1'
    'localhost',
=======
    'management',
>>>>>>> feature/Creating_models
]

MIDDLEWARE = [
    'debug_toolbar.middleware.DebugToolbarMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    # 'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    
]

ROOT_URLCONF = 'storyconnect.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'storyconnect.wsgi.application'


# Database
# https://docs.djangoproject.com/en/4.1/ref/settings/#databases

# def getHost():
#     print(os.getenv('HOST'))
#     return os.getenv('HOST')

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'HOST': os.getenv('HOST'),
        'NAME': os.getenv('NAME'),
        'PORT': os.getenv('PORT'),
        'USER': os.getenv('DBUSER'),
        'PASSWORD':  os.getenv('PASSWORD').strip(), 
        'OPTIONS': {'sslmode': os.getenv('SSLMODE')},
    }
}



# Password validation
# https://docs.djangoproject.com/en/4.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]



# Internationalization
# https://docs.djangoproject.com/en/4.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.1/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")


# Default primary key field type
# https://docs.djangoproject.com/en/4.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'



# FIREBASE CREDENTIALS
FIREBASE_ACCOUNT_TYPE = os.environ.get('FIREBASE_ACCOUNT_TYPE')
FIREBASE_PROJECT_ID = os.environ.get('FIREBASE_PROJECT_ID')
FIREBASE_PRIVATE_KEY_ID = os.environ.get('FIREBASE_PRIVATE_KEY_ID')
FIREBASE_PRIVATE_KEY = os.environ.get('FIREBASE_PRIVATE_KEY')
FIREBASE_CLIENT_EMAIL = os.environ.get('FIREBASE_CLIENT_EMAIL')
FIREBASE_CLIENT_ID = os.environ.get('FIREBASE_CLIENT_ID')
FIREBASE_AUTH_URI = os.environ.get('FIREBASE_AUTH_URI')
FIREBASE_TOKEN_URI = os.environ.get('FIREBASE_TOKEN_URI')
FIREBASE_AUTH_PROVIDER_X509_CERT_URL = os.environ.get('FIREBASE_AUTH_PROVIDER_X509_CERT_URL')
FIREBASE_CLIENT_X509_CERT_URL = os.environ.get('FIREBASE_CLIENT_X509_CERT_URL')

cred = credentials.Certificate(
    {
        "type": "service_account",
        "project_id": os.environ.get("FIREBASE_PROJECT_ID"),
        "private_key_id": os.environ.get("FIREBASE_PRIVATE_KEY_ID"),
        "private_key": os.environ.get("FIREBASE_PRIVATE_KEY").replace("\\n", "\n"),
        "client_email": os.environ.get("FIREBASE_CLIENT_EMAIL"),
        "client_id": os.environ.get("FIREBASE_CLIENT_ID"),
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://accounts.google.com/o/oauth2/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": os.environ.get("FIREBASE_CLIENT_CERT_URL"),
    }
)


# cred = firebase_admin.credentials.Certificate('storyconnect/firbase_credentials.json', options = {'storageBucket' : 'gs://storyconnect-9c7dd.appspot.com'})
default_app = firebase_admin.initialize_app(cred, name='[DEFAULT]', options = {'storageBucket' : 'gs://storyconnect-9c7dd.appspot.com'})

FIREBASE_BUCKET = storage.bucket(app=default_app, name= 'storyconnect-9c7dd.appspot.com')

REST_FRAMEWORK = {'DEFAULT_AUTHENTICATION_CLASSES' : ['rest_framework.authentication.SessionAuthentication',
                                                    'core.authentication.FirebaseAuthentication']}

# REST_FRAMEWORK = {
#     'EXCEPTION_HANDLER': 'rest_framework_json_api.exceptions.exception_handler',
#     'DEFAULT_PARSER_CLASSES': (
#         'rest_framework_json_api.parsers.JSONParser',
#     ),
#     'DEFAULT_AUTHENTICATION_CLASSES': [
#         'rest_framework.authentication.TokenAuthentication',
#     ],
#     'DEFAULT_RENDERER_CLASSES': (
#         'rest_framework_json_api.renderers.JSONRenderer',
#         'rest_framework.renderers.BrowsableAPIRenderer'
#     ),
#     'DEFAULT_METADATA_CLASS': 'rest_framework_json_api.metadata.JSONAPIMetadata',
#     'DEFAULT_FILTER_BACKENDS': (
#         'rest_framework_json_api.filters.QueryParameterValidationFilter',
#         'rest_framework_json_api.filters.OrderingFilter',
#         'rest_framework_json_api.django_filters.DjangoFilterBackend',
#         'rest_framework.filters.SearchFilter',
#     ),
#     'SEARCH_PARAM': 'filter[search]',
#     'TEST_REQUEST_RENDERER_CLASSES': (
#         'rest_framework_json_api.renderers.JSONRenderer',
#     ),
#     'TEST_REQUEST_DEFAULT_FORMAT': 'vnd.api+json'
# }