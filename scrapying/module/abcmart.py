from bs4 import BeautifulSoup
import urllib.request as req
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import pandas as pd

def scrapying(brandName,short):
    # 웹 사이트 열기
    chrom_options = webdriver.ChromeOptions()
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()),options=chrom_options)
    driver.get('https://abcmart.a-rt.com/')

    time.sleep(30)

    # 브랜드 클릭
    xpath = '//*[@id="gnbMenuWrap"]/ul/li[1]/a'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(10)

    # 텍스트 필드에 브랜드 이름 넣기
    driver.find_element(By.XPATH,'//*[@id="brandSearch"]').send_keys(brandName)

    # 클릭하기
    xpath=f'//*[@id="brandName{short}"]/ul/li[4]/a/span[1]'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(10)

    # 첫번쨰 페이지 크롤링 해오기 위해서 스크롤 내리기
    driver.execute_script('window.scrollTo(0, document.body.scrollHeight / 5);')

    time.sleep(10)

    # 카테고리 신발 선택하기
    xpath = '//*[@id="isubCatListLi1000000441"]/div[1]'
    driver.find_element(By.XPATH,xpath).click()
    xpath = '//*[@id="isubCatListLi1000000441"]/div[2]/ul/li[1]/span/label'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(10)

    # beatufiul soup으로 scrapying 하기
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser') 

    # 브랜드 , 이름 , 가격 , 사진 가져오기
    prodBrand=soup.select('.prod-brand')
    prodName = soup.select('.prod-name')
    prodPrice = soup.select('.price-cost')
    prodImage = soup.select('.search-prod-image')


    # 브랜드 , 이름 , 가격 dataframe으로 만들기
    brand = []
    name = []
    price = []
    for i in range(7,37):
        brand.append(prodBrand[i].string)
        name.append(prodName[i].string)
        price.append(prodPrice[i].string.strip('\n''\t').replace(',',''))

    df = pd.DataFrame({
        'brand':brand,
        'name':name,
        'price':price
    })      
    
    # 이미지는 브랜드 + 이름으로 저장하기
    i = 0

    for image in prodImage:
        url = image.attrs['src']
        saveName = f'./신발 이미지/{brandName}/{df["brand"][i]}-{df["name"][i]}.jpg'

        try:
            req.urlretrieve(url, saveName)
        except Exception as e:
            print(e)
        
        i += 1

    time.sleep(5)

    # 2페이지 부터 위에꺼를 반복하기
    for i in range(2,11):
        xpath=f'//*[@id="pagingDiv"]/div/ol/li[{i}]/button'
        driver.find_element(By.XPATH,xpath).click()

        # 로딩 때문에 잠시 대기
        time.sleep(10)

        # 첫번쨰 페이지 크롤링 해오기 위해서 스크롤 내리기
        driver.execute_script('window.scrollTo(0, document.body.scrollHeight / 5);')

        time.sleep(10)

        # beatufiul soup으로 scrapying 하기
        html = driver.page_source
        soup = BeautifulSoup(html, 'html.parser') 


        # 브랜드 , 이름 , 가격 , 사진 가져오기
        prodBrand=soup.select('.prod-brand')
        prodName = soup.select('.prod-name')
        prodPrice = soup.select('.price-cost')
        prodImage = soup.select('.search-prod-image')


        # 브랜드 , 이름 , 가격 dataframe으로 만들기
        brand = []
        name = []
        price = []
        for i in range(7,37):
            brand.append(prodBrand[i].string)
            name.append(prodName[i].string)
            price.append(prodPrice[i].string.strip('\n''\t').replace(',',''))

        df2 = pd.DataFrame({
            'brand':brand,
            'name':name,
            'price':price
        })      
        
        # 이미지는 브랜드 + 이름으로 저장하기
        i = 0

        for image in prodImage:
            url = image.attrs['src']
            saveName = f'./신발 이미지/{brandName}/{df2["brand"][i]}-{df2["name"][i]}.jpg'

            try:
                req.urlretrieve(url, saveName)
            except Exception as e:
                print(e)
            
            i += 1

        df = pd.concat([df,df2])
        df.reset_index(drop=True,inplace=True)

        time.sleep(5)
    

    # 다 합친 df csv로 저장하기
    df.to_csv(f'./csv/{brandName}.csv',index=False)


def scrapying_converse(brandName,short):
    # 웹 사이트 열기
    chrom_options = webdriver.ChromeOptions()
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()),options=chrom_options)
    driver.get('https://abcmart.a-rt.com/')

    time.sleep(10)

    # 브랜드 클릭
    xpath = '//*[@id="gnbMenuWrap"]/ul/li[1]/a'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(5)

    # 텍스트 필드에 브랜드 이름 넣기
    driver.find_element(By.XPATH,'//*[@id="brandSearch"]').send_keys(brandName)

    # 클릭하기
    xpath=f'//*[@id="brandName{short}"]/ul/li[4]/a/span[1]'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(5)

    # 첫번쨰 페이지 크롤링 해오기 위해서 스크롤 내리기
    driver.execute_script('window.scrollTo(0, document.body.scrollHeight / 5);')

    time.sleep(5)

    # 카테고리 신발 선택하기
    xpath = '//*[@id="isubCatListLi1000000441"]/div[1]'
    driver.find_element(By.XPATH,xpath).click()
    xpath = '//*[@id="isubCatListLi1000000441"]/div[2]/ul/li[1]/span/label'
    driver.find_element(By.XPATH,xpath).click()

    time.sleep(5)

    # beatufiul soup으로 scrapying 하기
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser') 

    # 브랜드 , 이름 , 가격 , 사진 가져오기
    prodBrand=soup.select('.prod-brand')
    prodName = soup.select('.prod-name')
    prodPrice = soup.select('.price-cost')
    prodImage = soup.select('.search-prod-image')


    # 브랜드 , 이름 , 가격 dataframe으로 만들기
    brand = []
    name = []
    price = []
    for i in range(7,37):
        brand.append(prodBrand[i].string)
        name.append(prodName[i].string)
        price.append(prodPrice[i].string.strip('\n''\t').replace(',',''))

    df = pd.DataFrame({
        'brand':brand,
        'name':name,
        'price':price
    })      
    
    # 이미지는 브랜드 + 이름으로 저장하기
    i = 0

    for image in prodImage:
        url = image.attrs['src']
        saveName = f'./신발 이미지/{brandName}/{df["brand"][i]}-{df["name"][i]}.jpg'

        try:
            req.urlretrieve(url, saveName)
        except Exception as e:
            print(e)
        
        i += 1


    # 2페이지 부터 위에꺼를 반복하기
    for i in range(2,4):
        xpath=f'//*[@id="pagingDiv"]/div/ol/li[{i}]/button'
        driver.find_element(By.XPATH,xpath).click()

        # 로딩 때문에 잠시 대기
        time.sleep(5)

        # 첫번쨰 페이지 크롤링 해오기 위해서 스크롤 내리기
        driver.execute_script('window.scrollTo(0, document.body.scrollHeight / 5);')

        time.sleep(5)

        # beatufiul soup으로 scrapying 하기
        html = driver.page_source
        soup = BeautifulSoup(html, 'html.parser') 


        # 브랜드 , 이름 , 가격 , 사진 가져오기
        prodBrand=soup.select('.prod-brand')
        prodName = soup.select('.prod-name')
        prodPrice = soup.select('.price-cost')
        prodImage = soup.select('.search-prod-image')


        # 브랜드 , 이름 , 가격 dataframe으로 만들기
        brand = []
        name = []
        price = []
        for i in range(7,37):
            brand.append(prodBrand[i].string)
            name.append(prodName[i].string)
            price.append(prodPrice[i].string.strip('\n''\t').replace(',',''))

        df2 = pd.DataFrame({
            'brand':brand,
            'name':name,
            'price':price
        })      
        
        # 이미지는 브랜드 + 이름으로 저장하기
        i = 0

        for image in prodImage:
            url = image.attrs['src']
            saveName = f'./신발 이미지/{brandName}/{df2["brand"][i]}-{df2["name"][i]}.jpg'

            try:
                req.urlretrieve(url, saveName)
            except Exception as e:
                print(e)
            
            i += 1

        df = pd.concat([df,df2])
        df.reset_index(drop=True,inplace=True)

    

    # 다 합친 df csv로 저장하기
    df.to_csv(f'./csv/{brandName}.csv',index=False)