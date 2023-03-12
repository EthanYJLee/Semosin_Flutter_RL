from bs4 import BeautifulSoup
import urllib.request as req
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import pandas as pd
import sys
import os
from multiprocessing import Pool
import json

def scrapying(brand,logo,start,page):
    chrom_options = webdriver.ChromeOptions()
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()),options=chrom_options)
    driver.get('https://abcmart.a-rt.com/')

    time.sleep(30)

    # 브랜드 클릭
    xpath = '//*[@id="gnbMenuWrap"]/ul/li[1]/a'
    driver.find_element(By.XPATH,xpath).click()

    ## 브랜드명만 바꿔주면 된다.
    driver.find_element(By.XPATH,'//*[@id="brandSearch"]').send_keys(brand)

    xpath=f'//*[@id="brandName{logo}"]/ul/li[4]/a/span[1]'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(10)

    driver.execute_script('window.scrollTo(0, document.body.scrollHeight / 5);')

    # 카테고리 신발 선택하기
    xpath = '//*[@id="isubCatListLi1000000441"]/div[1]'
    driver.find_element(By.XPATH,xpath).click()
    xpath = '//*[@id="isubCatListLi1000000441"]/div[2]/ul/li[1]/span/label'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(10)

    if page > 1:
        xpath=f'//*[@id="pagingDiv"]/div/ol/li[{page}]/button'
        driver.find_element(By.XPATH,xpath).click()
        time.sleep(10)

    shoes = []

    for j in range(start,start+5):
        xpath = '//*[@id="tabContentProd"]/div[3]/div[2]/div[2]/ul/li[%d]'%j
        driver.find_element(By.XPATH,xpath).click()

        time.sleep(10)
        
        driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')

        html = driver.page_source
        soup = BeautifulSoup(html, 'html.parser')

        shoe = {}

        shoe['brand'] = soup.select_one('.btn-brand').string
        shoe['model'] = soup.select_one('.prod-name').string
        shoe['price'] = soup.select_one('.price-cost').string.replace(',','')

        # 10일 경우
        details =soup.select('#product-detail-notice span')
        # 소재 , 색상 , 사이즈, 굽높이 , 제조사, 제조국 , a/s , 제조년월 , 품질보증기간 , 소재별 관리방법
        if len(details) >= 10:
            shoe['material'] = details[0].string
            shoe['colors'] = details[1].string
            shoe['sizes'] = details[2].string.split(' / ')
            shoe['height'] = details[3].string
            shoe['maker'] = details[4].string
            shoe['country'] = details[5].string
            shoe['method'] = details[9].string
        elif len(details) == 9:
            shoe['material'] = details[0].string
            shoe['colors'] = details[1].string
            shoe['sizes'] = details[2].string.split(' / ')
            shoe['maker'] = details[3].string
            shoe['country'] = details[4].string
            shoe['method'] = details[8].string

        # 이미지 가져오기
        images = soup.select('.swiper-slide img')
        saveNames = []
        i = 1
        temp = ''
        current = ''
        if brand == 'nike' or brand == 'adidas':
            for image in images:
                current = image.attrs['alt']
                if ('SUB' in temp and 'SUB' not in current and i != 1) :
                    break
                url = image.attrs['src'].replace('100:100','480:480')
                saveName = f'./신발 이미지/{brand}/{shoe["brand"]}-{shoe["model"]}-{i}.jpg'
                saveNames.append(saveName)
                temp = current
                try:
                    req.urlretrieve(url, saveName)
                    i += 1
                except Exception as e:
                    print(e)
        elif brand == 'converse':
            for image in images:
                if i > 5: break
                url = image.attrs['src'].replace('100:100','480:480')
                saveName = f'./신발 이미지/{brand}/{shoe["brand"]}-{shoe["model"]}-{i}.jpg'
                saveNames.append(saveName)
                try:
                    req.urlretrieve(url, saveName)
                    i += 1
                except Exception as e:
                    print(e)

        shoe['images'] = saveNames

        shoes.append(shoe)

        print(shoe['brand'] + '-' + shoe['model'])

        # 뒤로 가기
        driver.back()

        time.sleep(10)

        driver.execute_script('window.scrollTo(0, document.body.scrollHeight / 5);')


        time.sleep(10)

    filepath = f'./{brand}_page_{page}_{start}.json'

    with open(filepath,'w') as f:
        json.dump(shoes,f)

    # return shoes



if __name__ == "__main__":

    # recursionlimit 늘려주기
    sys.setrecursionlimit(10**6)

    p = Pool(6)

    # multi processing
    ret1 = p.apply_async(scrapying,('converse','C',1,3))
    ret2 = p.apply_async(scrapying,('converse','C',6,3))
    ret3 = p.apply_async(scrapying,('converse','C',11,3))
    ret4 = p.apply_async(scrapying,('converse','C',16,3))
    ret5 = p.apply_async(scrapying,('converse','C',21,3))
    ret6 = p.apply_async(scrapying,('converse','C',26,3))

    # result = ret1.get() + ret2.get() + ret3.get() + ret4.get() + ret5.get() + ret6.get()

    # with open('../json/nike_page1.json','w') as f:
    #     json.dump(result,f)

    p.close()
    p.join()