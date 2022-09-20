from pathlib import Path

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By

GOOGLE_FORMS_URL = "https://forms.gle/NNrmzVaQnHwVt8sYEA"
NAME_XPATH = '//*[@id="mG61Hd"]/div[2]/div/div[2]/div[2]/div/div/div[2]/div/div[1]/div/div[1]/input'
EMAIL_XPATH = '//*[@id="mG61Hd"]/div[2]/div/div[2]/div[3]/div/div/div[2]/div/div[1]/div/div[1]/input'
ID_XPATH = '//*[@id="mG61Hd"]/div[2]/div/div[2]/div[4]/div/div/div[2]/div/div[1]/div/div[1]/input'
SUBMIT_XPATH = '//*[@id="mG61Hd"]/div[2]/div/div[3]/div[1]/div[1]/div'

data = {
    "email": "test@fake.com",
    "name": "Godofredo El Grande",
    "work_id": "H636H",
}

s = Service(str(Path.home() / "bin/opt/chromedriver"))
option = webdriver.ChromeOptions()
option.add_argument("-incognito")
option.add_experimental_option("excludeSwitches", ["enable-automation"])
browser = webdriver.Chrome(service=s, options=option)

browser.get(GOOGLE_FORMS_URL)

square_boxes = browser.find_elements(
    By.CLASS_NAME, "docssharedWizToggleLabeledContainer"
)
square_boxes[2].click()

name_answer = browser.find_element(By.XPATH, NAME_XPATH)
name_answer.send_keys(data["name"])

email_answer = browser.find_element(By.XPATH, EMAIL_XPATH)
email_answer.send_keys(data["email"])

id_answer = browser.find_element(By.XPATH, ID_XPATH)
id_answer.send_keys(data["work_id"])

submit_button = browser.find_element(By.XPATH, SUBMIT_XPATH)
submit_button.click()

browser.close()
