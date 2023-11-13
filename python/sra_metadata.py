#!/usr/bin/env python

import argparse
import sys
import time
from pathlib import Path

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as ec
from selenium.webdriver.support.ui import WebDriverWait


def read_params():
    p = argparse.ArgumentParser(
        description="Download metadata from SRA Run Selector",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument("--id", "-i", metavar="\b", required=True, help="BioProject ID")

    if len(sys.argv) == 1:
        p.print_help()
        p.exit()

    return p.parse_args()


def sra_metadata_mac(acc_id: str) -> None:
    s = Service(str(Path.home() / "bin/opt/chromedriver"))
    options = webdriver.ChromeOptions()
    options.binary_location = (
        "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
    )
    prefs = {
        "profile.default_content_settings.popups": False,
        "download.default_directory": str(Path.home()),
        "profile.default_content_setting_values.automatic_downloads": 1,
    }

    options.add_argument("headless")
    options.add_experimental_option("excludeSwitches", ["enable-automation"])
    options.add_experimental_option("prefs", prefs)

    browser = webdriver.Chrome(service=s, options=options)
    url_run_selector = "https://www.ncbi.nlm.nih.gov/Traces/study/"
    browser.get(url_run_selector)
    browser.implicitly_wait(10)
    input_xpath = ".//*[@id='id-search-form']/div[2]/input"
    browser.find_element("xpath", input_xpath).send_keys(acc_id)
    browser.find_element("xpath", ".//*[@id='id-search-form']/div[2]/button").click()
    wait = WebDriverWait(browser, 12)
    wait.until(ec.element_to_be_clickable((By.ID, "t-rit-all")))
    browser.find_element(By.ID, "t-rit-all").click()
    browser.close()

    time.sleep(4)
    sra_file = Path.home() / "SraRunTable.txt"
    sra_file.rename(Path.home() / f"{acc_id}_SraRunTable.csv")


def main():
    args = read_params()
    accession_id = args.id
    sra_metadata_mac(accession_id)


if __name__ == "__main__":
    main()
