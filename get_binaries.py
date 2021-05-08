import sys
import os
import gdown
import shutil
from zipfile import ZipFile

#Needs both of these for some weird reason.
import distutils
from distutils import dir_util

import requests
import json



def fetch_id_json():
    json_generator_data = {
        'id' : '1i4xYe-Y3xNvkP4R1vBDZLz7o5wcDs6bT'
    }
    json_generator_url = "https://script.google.com/macros/s/AKfycbwFmdcnk7G2rGCkmBY_nI3X4dgZaZIdT7ZNG6hgr_Q1LLqKUOkuaL4m_4W6yFy1VgjwKQ/exec"

    result = requests.get(json_generator_url, allow_redirects=True, params=json_generator_data)
    
    id_json = json.loads(result.text)
    return id_json


def main():
    url = "https://drive.google.com/uc?id=1r2cYJ4Dhlv4LUHG_6lazFy89kIf-JiBt"
    out = "binaries/bin.zip"
    
    yes_dict = {
        "y" : True,
        "yes": True,
        "yea": True
    }

    if not os.path.exists("binaries"):
        os.mkdir("binaries")

    if os.path.exists("binaries/bin.zip"):
        answer = input("Binaries already exist redownload?\n")
        if answer.lower() in yes_dict:
            os.remove("binaries/bin.zip")
            gdown.download(url, out, quiet=False)
    else:
        pass
        #gdown.download(url, out, quiet=False)

    with ZipFile("binaries/bin.zip", 'r') as zipObj:
        print("Extracting...")
        zipObj.extractall("binaries")
        print("Merging...")
        distutils.dir_util.copy_tree("binaries/Community A-4E Binaries", "A-4E-C")
        print("Removing Extracted Directories...")
        shutil.rmtree("binaries/Community A-4E Binaries")
        print("Done.")
    

if __name__ == "__main__":
    main()
