# Generated by Django 4.2.5 on 2023-11-18 02:14

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0004_profile_profile_image_url'),
    ]

    operations = [
        migrations.RenameField(
            model_name='profile',
            old_name='profile_image_url',
            new_name='image_url',
        ),
    ]