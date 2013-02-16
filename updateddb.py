#! /usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals

from sqlobject import *
from sqlobject.sqlbuilder import *

import urllib2, re
from bs4 import BeautifulSoup

import time
from datetime import date


#### open db connection
connection_string = 'postgres://nastya:simple@localhost/realestate' 
connection = connectionForURI(connection_string)
sqlhub.processConnection = connection

print 'connection setup'

#### select existing object in db
select = Select(['code'], staticTables = ['Flat'])
query = connection.sqlrepr(select)
rows = connection.queryAll(query)

print 'check existing object'

### get links
url = 'http://www.real-estate.lviv.ua/sale-kvartira/Lviv'
page = urllib2.urlopen(url)
soup = BeautifulSoup(page)

### get number of pages
additional_list = []
all_links = soup.find(class_ = "search_result")
links1 = all_links.find_all("a")
last_page = links1[-1].get("href")
n=last_page.split("_")

last_page_number = n[1]

print 'number of pages =' + str(last_page_number)

### get list of links:
updated_list = []
exist_list = []
for i in range(1, (int(last_page_number)+1)):
    cur_url = "http://www.real-estate.lviv.ua/sale-kvartira/Lviv/p_" + str(i)
    page = urllib2.urlopen(cur_url)
    soup = BeautifulSoup(page)
    print 'checking page' + str(i)
    
    linkslist = soup.find_all(class_ = "adr")
    for x in linkslist:
      urllist = x.find_all("a")

      for link in urllist:
          testlink = link.get("href")
          testsplit = testlink.split('-')
          s = testsplit[0][1:]
          sint = int(s)
          test = (sint, )
          if test in rows:
              exist_list.append(s)
          else:
              updated_list.append("http://www.real-estate.lviv.ua" + testlink)
    print 'Checked'    

#### exist_list - визначити notexists, create column, add data of notexists values in column
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
    notexistsdate = StringCol()    
    


#get data of updating
today = date.today()
updated_date = today.strftime("%d.%m.%Y")

### get codes of non-existing items
notexistcode = [f.code for  f in Flat.select(NOTIN(Flat.q.code, exist_list))]

### marked non-exists data in db:
count = 0
for nonex in notexistcode:
	update = Update('Flat', values = {'notexistsdate': updated_date}, where = ('code =' + str(nonex)))
	query = connection.sqlrepr(update)
	connection.query(query)
	print str(nonex)+" object not exists. Updated"
	count = count + 1
print str(count) + '  objects updated'

count = 0
### updated_list
for line in updated_list:
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
            'Стан': 'NULL',
            'Видалено': 'NULL'
            }
    
            
            
    description = soup.find("h2").get_text()
    desc = description.split(": ")
    flat['Адреса'] =  desc[1]
    features = soup.find_all("tr")
    
    for i in features:
        f = i.get_text()
        f_list = f.split(":")
        x = f_list[0]
        if  x in flat:
            flat[x] = f_list[1]

    f = Flat(adress = flat['Адреса'].encode('utf-8'),walls = flat['Матеріал стін'].encode('utf-8'), price = flat['Ціна'].encode('utf-8'), area = flat['Загальна площа'].encode('utf-8'), living_area = flat['Житлова площа'].encode('utf-8'), kitchen_area = flat['Площа кухні'].encode('utf-8'), dollar_price = flat['Ціна $'].encode('utf-8'), building_type = flat['Тип будівлі'].encode('utf-8'), floors_number = int(flat['Поверховість будівлі']), floor = int(flat['Поверх']), days = int(flat['Днів на сайті']), balcony = int(flat['Кількість балконів']), rooms = int(flat['Кімнат']), code = int(flat['Код квартири']), updated = flat['Оновлено'].encode('utf-8'), condition = flat['Стан'].encode('utf-8'), notexistsdate = flat['Видалено'].encode('utf-8'))

    print line
    count = count + 1
    
      
print 'Congratulation!'    
print str(count) + '  objects added'   

### close db connection
connection.close()

