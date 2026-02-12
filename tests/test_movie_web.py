from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from api.movie_api import get_popular_movie
import time


def test_search_movie_on_wikipedia():
    movie = get_popular_movie()

    options = Options()
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(options=options)
    driver.get("https://www.wikipedia.org")

    search_box = driver.find_element(By.NAME, "search")
    search_box.send_keys(movie)
    search_box.send_keys(Keys.RETURN)

    time.sleep(3)

    body_text = driver.find_element(By.TAG_NAME, "body").text
    assert movie.lower() in body_text.lower()

    driver.quit()