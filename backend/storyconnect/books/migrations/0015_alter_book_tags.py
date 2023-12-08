# Generated by Django 4.2.5 on 2023-12-03 19:27

import django.contrib.postgres.fields
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('books', '0014_alter_chapter_chapter_title'),
    ]

    operations = [
        migrations.AlterField(
            model_name='book',
            name='tags',
            field=django.contrib.postgres.fields.ArrayField(base_field=models.CharField(max_length=50), blank=True, default=list, size=None),
        ),
    ]
