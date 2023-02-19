from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from priv import username, password, amount
import time

# initialize the Chrome driver
driver = webdriver.Chrome("chromedriver")

# head to bofa login page
driver.get("https://www.bankofamerica.com/")
# find username/email field and send the username itself to the input field
driver.find_element("id", "onlineId1").send_keys(username)
# find password input field and insert password as well
driver.find_element("id", "passcode1").send_keys(password)
# click login button
driver.find_element("id", "signIn").click()
# click bill pay link
driver.find_element("name", "onh_bill_pay").click()
# find amount and enter amount
time.sleep(3)
driver.find_element("id", "amt-1").send_keys(amount)
# click make payment button
driver.find_element("id", "makePayments").click()
# pauses time to allow users to see demo (payment successful)
time.sleep(15)
