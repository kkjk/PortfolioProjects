# import libraries

from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime

import csv 
import pandas as pd

URL = 'https://www.amazon.de/-/en/Self-Empty-RV1000SEU-Automatic-Anti-Hair-Wrap-Technology/dp/B08ZSRD318/ref=pd_sbs_sccl_3_1/258-1599634-6476735?pd_rd_w=Rax7G&content-id=amzn1.sym.5cb0d797-c494-4ef9-9229-f54873a5d2fa&pf_rd_p=5cb0d797-c494-4ef9-9229-f54873a5d2fa&pf_rd_r=3A1DZZ8W8C0JF9T8VZEP&pd_rd_wg=9XvJ1&pd_rd_r=5efe943f-8888-4436-87b8-7801bd64166d&pd_rd_i=B08ZSRD318&th=1'

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0"}

page = requests.get(URL, headers=headers)

soup1 = BeautifulSoup(page.content, 'html.parser')

soup2 = BeautifulSoup(soup1.prettify(), 'html.parser')

title = soup2.find(id='productTitle').get_text().strip()

price = soup2.find_all('div', class_='a-price-whole')

color = soup2.find_all('div', class_='a-size-base')

today = datetime.date.today()

#     title = title.strip()
#     price = price.strip()[1:].split('\n')[0]
#     print(price)
#     print(title)

# print(soup2)
print(title)
print(price)
print(color)
print(today)

title = title.strip()
price = price.strip()[1:].split('\n')[0]
print(price)
print(title)


# csv_header = ['title', 'price', 'date']
data = [title, price, today]

with open('AmazonUPBWebScraping.csv', 'a+', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
#     writer.writerow(csv_header)
    writer.writerow(data)

df = pd.read_csv(r'C:\Users\keert\My Jupyter Notebooks\AmazonUPBWebScraping.csv')
print(df)
