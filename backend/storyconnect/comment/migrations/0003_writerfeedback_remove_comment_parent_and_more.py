# Generated by Django 4.2.4 on 2023-09-22 19:25

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('comment', '0002_rename_floatng_textselection_floating'),
    ]

    operations = [
        migrations.CreateModel(
            name='WriterFeedback',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('comment', models.TextField(blank=True, max_length=1000, null=True)),
                ('sentiment', models.IntegerField(blank=True, choices=[(0, 'Great'), (1, 'Good'), (2, 'Mediocre'), (3, 'Bad')], null=True)),
                ('dismissed', models.BooleanField(default=False)),
                ('suggestion', models.BooleanField(default=False)),
                ('posted', models.DateTimeField(auto_now_add=True)),
                ('edited', models.DateTimeField(auto_now=True)),
                ('parent', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='comment.writerfeedback')),
            ],
        ),
        migrations.RemoveField(
            model_name='comment',
            name='parent',
        ),
        migrations.RemoveField(
            model_name='comment',
            name='selection',
        ),
        migrations.RemoveField(
            model_name='comment',
            name='user',
        ),
        migrations.RenameField(
            model_name='textselection',
            old_name='length',
            new_name='offset_end',
        ),
        migrations.AddField(
            model_name='highlight',
            name='annotation',
            field=models.TextField(blank=True, max_length=1000, null=True),
        ),
        migrations.AlterField(
            model_name='highlight',
            name='selection',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='comment.textselection'),
        ),
        migrations.DeleteModel(
            name='Annotation',
        ),
        migrations.DeleteModel(
            name='Comment',
        ),
        migrations.AddField(
            model_name='writerfeedback',
            name='selection',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='comment.textselection'),
        ),
        migrations.AddField(
            model_name='writerfeedback',
            name='user',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
    ]