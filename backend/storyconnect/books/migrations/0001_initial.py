<<<<<<< HEAD
# Generated by Django 4.1.7 on 2023-04-14 17:31
=======
# Generated by Django 4.1.7 on 2023-04-19 10:15
>>>>>>> develop

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Book',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=100)),
                ('author', models.CharField(max_length=100)),
                ('language', models.CharField(max_length=20)),
                ('target_audience', models.IntegerField(choices=[(1, 'Young Adult (13-18 years old)'), (2, 'New Adult (18-25 years old)'), (3, 'Adult (25+ years old)')])),
                ('cover', models.ImageField(blank=True, upload_to='covers/')),
                ('date_created', models.DateTimeField(auto_now_add=True)),
                ('date_modified', models.DateTimeField(auto_now=True)),
                ('synopsis', models.TextField(max_length=1000)),
                ('copyright', models.IntegerField(choices=[(1, 'All Rights Reserved: No part of this publication may be reproduced, stored or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, scanning, or otherwise without written permission from the publisher. It is illegal to copy this book, post it to a website, or distribute it by any other means without permission.'), (2, 'Public Domain: This story is open source for the public to use for any purposes.'), (3, 'Creative Commons (CC) Attribution: Author of the story has some rights to some extent and allow the public to use this story for purposes like translations or adaptations credited back to the author.')])),
                ('titlepage', models.TextField()),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Chapter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('chapter_title', models.CharField(max_length=100)),
                ('chapter_content', models.TextField()),
                ('book', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='books.book')),
            ],
        ),
        migrations.CreateModel(
            name='Scene',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('scene_title', models.CharField(blank=True, max_length=100)),
                ('scene_content', models.TextField(blank=True)),
                ('chapter', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='books.chapter')),
            ],
        ),
        migrations.CreateModel(
            name='Location',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(blank=True, max_length=100)),
                ('description', models.TextField(blank=True)),
                ('book', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='books.book')),
            ],
        ),
        migrations.CreateModel(
            name='Library',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.IntegerField(choices=[(1, 'Reading'), (2, 'Archived')])),
                ('book', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='books.book')),
                ('reader', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Character',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(blank=True, max_length=100)),
                ('nickname', models.CharField(blank=True, max_length=100)),
                ('bio', models.CharField(blank=True, max_length=50)),
                ('description', models.TextField(blank=True)),
                ('image', models.ImageField(blank=True, upload_to='characters/')),
                ('attributes', models.CharField(blank=True, max_length=200)),
                ('book', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='books.book')),
            ],
        ),
    ]
