# Generated by Django 4.2.4 on 2023-09-05 18:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('books', '0003_alter_chapter_chapter_title_alter_chapter_content'),
    ]

    operations = [
        migrations.AlterField(
            model_name='book',
            name='copyright',
            field=models.IntegerField(blank=True, choices=[(0, 'All Rights Reserved: No part of this publication may be reproduced, stored or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, scanning, or otherwise without written permission from the publisher. It is illegal to copy this book, post it to a website, or distribute it by any other means without permission.'), (1, 'Public Domain: This story is open source for the public to use for any purposes.'), (2, 'Creative Commons (CC) Attribution: Author of the story has some rights to some extent and allow the public to use this story for purposes like translations or adaptations credited back to the author.')], null=True),
        ),
        migrations.AlterField(
            model_name='book',
            name='target_audience',
            field=models.IntegerField(blank=True, choices=[(0, 'Children '), (1, 'Young Adult'), (2, 'Adult (18+)')], null=True),
        ),
    ]
