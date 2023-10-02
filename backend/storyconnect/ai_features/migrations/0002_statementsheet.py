# Generated by Django 4.2.5 on 2023-10-02 21:11

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('books', '0008_delete_comments'),
        ('ai_features', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='StatementSheet',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('last_run_offset', models.IntegerField(default=0)),
                ('document', models.TextField(default='<Statements></Statements>')),
                ('book', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='statement_sheets', to='books.book')),
                ('last_run_chapter', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='books.chapter')),
            ],
        ),
    ]
