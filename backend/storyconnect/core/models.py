from django.db import models
from django.contrib.auth.models import User

# Create your models here.



## POSSIBLY UNNECESSARY FILE
## POSSIBLY UNNECESSARY FILE
## POSSIBLY UNNECESSARY FILE
## POSSIBLY UNNECESSARY FILE
## POSSIBLY UNNECESSARY FILE
## POSSIBLY UNNECESSARY FILE

## POSSIBLY UNNECESSARY FILE
## POSSIBLY UNNECESSARY FILE
class UserInformation(models.Model):
    account = models.ForeignKey(User, null=True,blank=True,  on_delete=models.CASCADE)
    username = models.CharField(max_length=100, null = False, blank = False)
    email = models.EmailField(max_length=254)
    
