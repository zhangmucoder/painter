__author__ = "Zhangmu Coder"


import requests,time
from PIL import Image,ImageEnhance
import pytesseract
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoAlertPresentException,NoSuchElementException,TimeoutException,NoSuchElementException


# code_url = "https://item.jd.com/100006394713.html#none" #袋鼠医生  15点预约 20点开枪
code_url = "https://item.jd.com/100011551632.html" #3Q口罩 15点预约 20点开枪
# code_url = "https://item.jd.com/100011521400.html" #振得口罩  21点开始预约  早上10点开枪
# code_url = "https://item.jd.com/100006426345.html" #亚都口罩  16点预约  14点开枪
driver = webdriver.Chrome()
driver.get(code_url)
soap = BeautifulSoup(driver.page_source, 'html.parser')
print(soap)

def login():
    login_JD = driver.find_element_by_class_name("link-login")
    login_JD.click()
    time.sleep(20)
    count = 0
    isRefresh = False
    while True:
        ticks = time.time()
        print("当前时间戳为:", ticks)
        # ticks > 1583323200
        if ticks >= 1583496000:
            if isRefresh == False:
                isRefresh = True
                driver.refresh()

            try:
                checkorder_elem = driver.find_element_by_xpath("//div[@class='checkout-steps']").is_displayed()
                if checkorder_elem:
                    driver.execute_script('window.scrollTo(0, document.body.scrollHeight)')
                    submit_elem = driver.find_element_by_xpath("//div[@class='inner']/button[1]")
                    if submit_elem:
                        submit_elem.click()
                    else:
                        driver.refresh()
                        driver.execute_script('window.scrollTo(0, document.body.scrollHeight)')
                        submit_elem = driver.find_element_by_xpath("//div[@class='inner']/button[1]")
                        submit_elem.click()

                    break
            except NoSuchElementException as e:
                print('没有提交订单的标签')
            try:
                account_elem_display = driver.find_element_by_xpath("//div[@id='choose-btns']/a[1]").is_displayed()
                if account_elem_display:
                    account_elem = driver.find_element_by_xpath("//div[@id='choose-btns']/a[1]")
                    if ticks >= 1583496000 and account_elem.text != "立即抢购":
                        #刷新页面
                        driver.refresh()
                        account_elem = driver.find_element_by_xpath("//div[@id='choose-btns']/a[1]")

                    if account_elem.text == '立即抢购':
                        count += 1
                        print('点击了', count, '次')
                        account_elem.click()
            except NoSuchElementException as e:
                print('没有下单按钮')
        else:
            print('抢购时间还没到')


#等待抢购
#立即抢购
#立即预约
#等待预约


































# soap = BeautifulSoup(driver.page_source, 'html.parser')
    # print(soap)

    # account_elem = driver.find_element_by_id('btn-reservation')

    # account_elem = driver.find_element_by_xpath("//div[@class='wrap-input']/a[2]")
    # account_elem.send_keys("15712881957")
    # passwd_elem = driver.find_element_by_id('password')
    # passwd_elem.send_keys('2158380zgc.')
    # login_btn = driver.find_element_by_id("loginBtn")
    # time.sleep(10)
    # account_elem = driver.find_element_by_xpath("//div[@id='choose-btns']/a[1]")

    # time.sleep(5)
    # card = driver.find_element_by_xpath("//div[@id='btService']/div[1]/a[4]")
    # card.click()
    # driver.execute_script('window.scrollTo(0, document.body.scrollHeight)')
    # ticket = driver.find_element_by_xpath("//div[@class = 'coupon-list']/div[4]")
    # ticket.click()
    # robber_select = driver.find_element_by_xpath("//div[@class = 'btnbottom-box']/a[1]")
    # count = 0
    # while True:
    #     count += 1
    #     robber_select.click()
    #     print('刷券第', count, '次')
    #     try:
    #         is_login = driver.find_element_by_id('username').is_displayed()
    #         if is_login:
    #             account_elem = driver.find_element_by_id('username')
    #             account_elem.send_keys("15712881957")
    #             passwd_elem = driver.find_element_by_id('password')
    #             passwd_elem.send_keys('2158380zgc.')
    #             login_btn = driver.find_element_by_id("loginBtn")
    #             login_btn.click()
    #             is_success = driver.find_element_by_id('h_realAmount').is_displayed()
    #             if is_success:
    #                 print('刷券成功')
    #                 break
    #     except NoSuchElementException as e:
    #         print('没有发现登录标签')
    #         try:
    #             is_success = driver.find_element_by_id('h_realAmount').is_displayed()
    #             if is_success:
    #                 print('刷券成功')
    #                 break
    #         except NoSuchElementException as e:
    #             continue


login()




































