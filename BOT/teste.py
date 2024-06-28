from selenium.webdriver.support.ui import Select  
import pandas as pd 
from selenium import webdriver
from time import sleep
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import pyautogui
from datetime import datetime

driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()))
url = ""
driver.implicitly_wait(2)
driver.get(url)
driver.maximize_window()