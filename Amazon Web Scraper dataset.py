#!/usr/bin/env python
# coding: utf-8

# In[1]:


#import libraries

from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime


# In[58]:


#connect to website

URL = 'https://www.amazon.in/Apple-iPhone-15-128-GB/dp/B0CHX2F5QT/ref=sr_1_4?crid=3SF2BMDIR8A4O&keywords=iphone%2B15&qid=1698219233&sprefix=iphone%2B15%2Caps%2C439&sr=8-4&th=1'

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0" , "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

page = requests.get(URL , headers=headers)

soup1 = BeautifulSoup(page.content , "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

title = soup2.find(id='productTitle')

if title:
    title = title.get_text(strip=True)  # Call get_text to get the text
    print(title)
else:
    print("Element with ID 'productTitle' not found")

price = soup2.find(id='corePriceDisplay_desktop_feature_div').get_text() 

print(price)


# In[11]:


price=price.strip()[1:]
print(price)


# In[12]:


price=price[:6]
print(price)


# In[21]:


import datetime

today = datetime.date.today()

print(today)


# In[30]:


import csv

header = ['productTile' , 'Price' , 'Date']
data = [title , price , today]

#with open(r'C:\Users\hp\OneDrive\Desktop\portfolio project\AmazonWebScraperData.csv','w',newline='',encoding = 'UTF8') as f:
    #writer = csv.writer(f)
    #writer.writerow(header)
    #writer.writerow(data)


# In[35]:


import pandas as pd

df = pd.read_csv(r'C:\Users\hp\OneDrive\Desktop\portfolio project\AmazonWebScraperData.csv')

print(df)


# In[34]:


#Now we are appending data to csv file 

with open(r'C:\Users\hp\OneDrive\Desktop\portfolio project\AmazonWebScraperData.csv','a+',newline='',encoding = 'UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(data)


# In[55]:


def check_price():
    
    URL = 'https://www.amazon.in/Apple-iPhone-15-128-GB/dp/B0CHX2F5QT/ref=sr_1_4?crid=3SF2BMDIR8A4O&keywords=iphone%2B15&qid=1698219233&sprefix=iphone%2B15%2Caps%2C439&sr=8-4&th=1'

    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0" , "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

    page = requests.get(URL , headers=headers)

    soup1 = BeautifulSoup(page.content , "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

    title = soup2.find(id='productTitle')

    if title:
        title = title.get_text(strip=True)  # Call get_text to get the text
        
    price = soup2.find(id='corePriceDisplay_desktop_feature_div').get_text() 

    if price_element:
        price=price.strip()[1:]
        price=price[:6]

    import datetime

    today = datetime.date.today()

    import csv

    header = ['productTile' , 'Price' , 'Date']
    data = [title , price , today]
    
    with open(r'C:\Users\hp\OneDrive\Desktop\portfolio project\AmazonWebScraperData.csv','a+',newline='',encoding = 'UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)

    
    


# In[60]:


while(True):
    check_price()
    time.sleep(5)
    


# In[59]:


import pandas as pd

df = pd.read_csv(r'C:\Users\hp\OneDrive\Desktop\portfolio project\AmazonWebScraperData.csv')

print(df)


# In[ ]:




