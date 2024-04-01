from selenium import webdriver
from selenium.webdriver.common.by import By
import numpy as np
import multiprocessing
import time
import requests
import random
import re
import cv2 
import os
from tqdm.auto import tqdm
import pandas as pd

def sum_frame(frame):
    return np.sum(frame, axis=None)

def compute_sum_multiprocess(lst_frame):
    pool = multiprocessing.Pool()
    result = pool.map(sum_frame, lst_frame)
    pool.close()
    pool.join()
    total_sum = sum(result)
    if total_sum == 0:
        return True
    else:
        return False
    
def check_video(response):
    cam = cv2.VideoCapture(response) 
    lst_frame = []
    while(True):
        ret, frame = cam.read()
        if ret:
            lst_frame.append(frame)
        else:
            break
    cam.release()
    cv2.destroyAllWindows()
    return lst_frame

def load_video(link):
    time.sleep(random.uniform(2.1, 8.1))
    check_error = 0
    while True:
        if check_error > 1:
            break
        else:
            try:
                chrome_options = webdriver.ChromeOptions()
                chrome_options.add_argument('--headless')
                chrome_options.add_argument("--log-level=1")  
                driver = webdriver.Chrome(options=chrome_options)
                driver.get("https://snaptik.app/")
                input_field = driver.find_element(By.ID, "url")
                input_field.send_keys(link)
                download_button = driver.find_element(By.XPATH, "//button[@aria-label='Get']")
                download_button.click()
                time.sleep(1)
                download_link = driver.find_element(By.XPATH, "//a[@class='button download-file']")
                download_url = download_link.get_attribute("href")
                driver.quit()
                response = requests.get(download_url,stream=True)
                if response.status_code == 200:
                    break
                elif check_error > 10:
                    break
                else:
                    time.sleep(random.uniform(2.1, 10))
            except:
                response = requests.get("https://api.github.com/rtestfgfd")
        check_error += 1
        
    return response

def down_tiktok(link):
    lst = link.rsplit("/")
    file_name = str(re.sub(r'@', '', lst[-3])) + "_" + str(lst[-1]) + ".mp4"
    path_save = "/home/admin_1/working/bigdata/tiktok_video/" + file_name
    if os.path.exists(path_save):
        return file_name
    else:
        response = load_video(link)
        if response.status_code == 200:
            try:
                try:
                    with open(path_save, 'wb') as file:
                            for chunk in response.iter_content(chunk_size=1024*1024):  # Download in 1 MB chunks
                                if chunk:  # filter out keep-alive new chunks
                                    file.write(chunk)
                except:
                    with open(path_save, 'wb') as f:
                        f.write(response.content)
                lst_frame = check_video(path_save)
                result = compute_sum_multiprocess(lst_frame)
                if result == True:
                    try:
                        os.remove(path_save)
                    except:
                        pass
                    return "No_video"
                else:
                    return file_name
            except:
                return "Error"
        else:
            return "Error"

if __name__ == "__main__":
    df = pd.read_csv("data_set_tiktok.csv",low_memory=False)
    tqdm.pandas(desc="loading..", ncols=90)
    df['file_name'] = df['webVideoUrl'].progress_apply(down_tiktok)
    df.to_csv("data_set_tiktok_update.csv",index=False)
