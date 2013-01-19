#! /usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals

import time

import urllib2, re
from bs4 import BeautifulSoup

##### SQL Object
from sqlobject import *
connection_string = 'postgres://nastya:simple@localhost/realestate' 
connection = connectionForURI(connection_string)
sqlhub.processConnection = connection

class Flat(SQLObject):
    adress = StringCol()
    walls = StringCol()
    price = StringCol()
    area = StringCol()
    living_area = StringCol()
    kitchen_area = StringCol()
    dollar_price = StringCol()
    building_type = StringCol()
    floors_number = IntCol()
    floor = IntCol()
    days = IntCol()
    balcony = IntCol()
    rooms = IntCol()
    code = IntCol()
    updated = StringCol()
    condition = StringCol()

#Flat.createTable()

f = open('unirealtylinks1.txt','r')
for line in f.readlines():
    url = line
    page = urllib2.urlopen(url)
    soup = BeautifulSoup(page)

    flat = {'Адреса': 'NULL',
            'Матеріал стін': 'NULL',
            'Ціна': 'NULL',
            'Загальна площа': 'NULL',
            'Житлова площа': 'NULL',
            'Площа кухні': 'NULL',
            'Ціна $': 'NULL',
            'Тип будівлі': 'NULL',
            'Поверховість будівлі': 0,
            'Поверх': 0,
            'Днів на сайті': 200000,
            'Кількість балконів': 100,
            'Кімнат': 0,
            'Код квартири': 0,
            'Оновлено': 'NULL',
            'Стан': 'NULL'
            }


    description = soup.find("h2").get_text()
    desc = description.split(": ")
    ### adress
    flat['Адреса'] =  desc[1]
    ### get all features:
    features = soup.find_all("tr")

    for i in features:
        f = i.get_text()
        f_list = f.split(":")
        x = f_list[0]
        if  x in flat:
            flat[x] = f_list[1]
        
        
    f = Flat(adress = flat['Адреса'].encode('utf-8'),walls = flat['Матеріал стін'].encode('utf-8'), price = flat['Ціна'].encode('utf-8'), area = flat['Загальна площа'].encode('utf-8'), living_area = flat['Житлова площа'].encode('utf-8'), kitchen_area = flat['Площа кухні'].encode('utf-8'), dollar_price = flat['Ціна $'].encode('utf-8'), building_type = flat['Тип будівлі'].encode('utf-8'), floors_number = int(flat['Поверховість будівлі']), floor = int(flat['Поверх']), days = int(flat['Днів на сайті']), balcony = int(flat['Кількість балконів']), rooms = int(flat['Кімнат']), code = int(flat['Код квартири']), updated = flat['Оновлено'].encode('utf-8'), condition = flat['Стан'].encode('utf-8'))

    print '....'
#    time.sleep(5)

print 'Congratulation!'

f.close()






    
    

    











