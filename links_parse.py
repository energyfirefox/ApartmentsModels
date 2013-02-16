#! /usr/bin/env python

import urllib2, re
from bs4 import BeautifulSoup
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

### get list of links:
s = []
for i in range(1, (int(last_page_number)+1)):
    cur_url = "http://www.real-estate.lviv.ua/sale-kvartira/Lviv/p_" + str(i)
    page = urllib2.urlopen(cur_url)
    soup = BeautifulSoup(page)
    
    linkslist = soup.find(class_ = "adr")
    urllist = linkslist.find_all("a")

    for link in urllist:
        s.append("http://www.real-estate.lviv.ua" + link.get("href"))

   

f = open('realtylinks.html', 'w')
f1 = open('realtylinks.txt', 'w')

print >> f, "<meta charset='utf-8'>"

for url in s:
    print >> f, url, "<br>"
    print >> f1, url

f.close()
f1.close()







    

    
        
        

