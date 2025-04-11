import time
import traceback
import os
import random
import urllib.parse
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from fastapi import FastAPI
import uvicorn
import threading

app = FastAPI()

def run_bot():
    try:
        bot_dir = os.path.dirname(os.path.abspath(__file__))
        chrome_profile_path = os.path.join(bot_dir, "wa_profile")

        options = webdriver.ChromeOptions()
        options.add_argument("--headless=new")
        options.add_argument("--disable-gpu")
        options.add_argument("--window-size=1920,1080")
        options.add_argument(f"--user-data-dir={chrome_profile_path}")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")

        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=options)

        driver.get("https://web.whatsapp.com/")
        print("🔐 Waiting 20 seconds for WhatsApp Web to load...")
        time.sleep(20)

        phone_numbers = ["916372833479", "916372833479"]
        message = """*‼️FREE‼️FREE‼️ FREE ‼️*\n*#🌙Chessy Me Tournament ♟️* ..."""
        encoded_message = urllib.parse.quote(message)

        message_count = 0
        hibernate_after = random.randint(35, 55)

        for phone_number in phone_numbers:
            try:
                url = f"https://web.whatsapp.com/send?phone={phone_number}&text={encoded_message}"
                driver.get(url)
                time.sleep(random.randint(25, 35))

                for _ in range(3):
                    try:
                        send_button = driver.find_element(By.XPATH, '//button[@aria-label="Send"]')
                        send_button.click()
                        break
                    except:
                        time.sleep(5)

                print(f"✅ Message sent to {phone_number}")
                message_count += 1

                if message_count >= hibernate_after:
                    sleep_duration = random.randint(300, 480)
                    print(f"💤 Hibernating for {sleep_duration // 60} mins...")
                    time.sleep(sleep_duration)
                    message_count = 0
                    hibernate_after = random.randint(35, 55)

                delay = random.randint(50, 80)
                print(f"⏳ Sleeping for {delay} seconds...")
                time.sleep(delay)

            except Exception as e:
                traceback.print_exc()

        print("🎯 All messages sent.")
        driver.quit()
    except Exception as e:
        traceback.print_exc()

@app.get("/")
def root():
    return {"status": "Bot running in Render!"}

# Run the bot in a separate thread when the app starts
threading.Thread(target=run_bot).start()
