import sys
import os
import gdown
from google_drive_downloader import GoogleDriveDownloader as gdd
import shutil
from zipfile import ZipFile
import threading
import math

#Needs both of these for some weird reason.
import distutils
from distutils import dir_util

import requests
import json

yes_dict = {
        "y" : True,
        "yes": True,
        "yea": True
    }

def fetch_id_json():
    json_generator_data = {
        'id' : '1i4xYe-Y3xNvkP4R1vBDZLz7o5wcDs6bT'
    }
    json_generator_url = "https://script.google.com/macros/s/AKfycbwFmdcnk7G2rGCkmBY_nI3X4dgZaZIdT7ZNG6hgr_Q1LLqKUOkuaL4m_4W6yFy1VgjwKQ/exec"

    result = requests.get(json_generator_url, allow_redirects=True, params=json_generator_data)
    
    with open("binaries/file_ids.json", "w+") as f:
        f.write(result.text)
        f.close()

    #id_json = json.loads(result.text)
    #return id_json

def old_download_method():
    url = "https://drive.google.com/uc?id=1r2cYJ4Dhlv4LUHG_6lazFy89kIf-JiBt"
    out = "binaries/bin.zip"
    
    

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


def create_download_link(id):
    return id #"https://drive.google.com/uc?id=" + 




class FileDownloader:
    def __init__(self, root, path):
        self.root = root

        self.root["path"] = path + "/" + self.root["foldername"]


        self.size_downloaded = 0
        self.files_downloaded = 0
        self.files_existing = 0
        self.total_files = 0
        self.file_queue = []

    def begin_download(self):

        self.threads = []

        if not os.path.exists(self.root["path"]):
            os.mkdir(self.root["path"])

        self.create_folders()

        #for dir in self.root["folders"]:
            #dir["path"] = self.root["path"] + "/" + dir["foldername"]

            #self.threads.append(threading.Thread(target=self.download_files, args=(dir,)))
            #self.threads[-1].start()

        for i in range(16):
            self.threads.append(threading.Thread(target=self.downloader_loop))
            self.threads[-1].start()


        for thread in self.threads:
            thread.join()


        total = self.files_downloaded + self.files_existing
        print("\n{} files downloaded. {} pre-existing, {}/{} (total/expected)".format(self.files_downloaded, self.files_existing, total, self.total_files ))

        return total == self.total_files




    def count_files(self):
        folder_stack = [self.root]
        self.total_files = 0
        while folder_stack:
            dir = folder_stack.pop()

            self.total_files += len(dir["files"])

            for folder in dir["folders"]:
                folder_stack.append(folder)

    def create_folders(self):
        folder_stack = [self.root]

        while folder_stack: 
            dir = folder_stack.pop()
            path = dir["path"]

            if not os.path.exists(path):
                os.mkdir(path)

            for file in dir["files"]:
                file_path = os.path.join(path, file["filename"])
                self.file_queue.append({
                    "url" : create_download_link(file["fileID"]),
                    "path" : file_path,
                })
                #pass #print(file["fileID"])

            for folder in dir["folders"]:
                folder["path"] = path + "/" + folder["foldername"]
                folder_stack.append(folder)

    def downloader_loop(self):
        while self.file_queue:
            self.download_files()

    def download_files(self):

        if self.file_queue:
            file = self.file_queue.pop()


            if not os.path.exists(file["path"]):
                try:
                    gdd.download_file_from_google_drive(file_id=file["url"], dest_path=file["path"], showsize=True)
                    #gdown.download(file["url"], file["path"], quiet=True)
                except Exception as e:
                    print("\nError ({}): requeuing file {}...".format(type(e).__name__, file["path"]))
                    self.file_queue.append(file)
                    return

                self.size_downloaded += float(os.path.getsize(file["path"]))
                self.files_downloaded += 1
                sys.stdout.write("{}/{} files downloaded totaling {} MB\n".format(self.files_downloaded, self.total_files, int(self.size_downloaded / 1.0e3)))
                
            else:
                print("Skipping {}".format(file["path"]))
                self.files_existing += 1
        
    

def copy_and_merge_files():
    print("Merging...")
    distutils.dir_util.copy_tree("binaries/Community A-4E Binaries", "A-4E-C")
    print("Done.")



def main():

    if not os.path.exists("binaries"):
        os.mkdir("binaries")

    if os.path.exists("binaries/file_ids.json"):
        answer = input("File ID JSON already exists, Generate a new one? ")
        if answer.lower() in yes_dict:
            os.remove("binaries/file_ids.json")
            fetch_id_json()
    else:
        fetch_id_json()

    if os.path.exists("binaries/Community A-4E Binaries"):
        answer = input("Binaries directory exists, Redownload? (no will download only missing files) ")
        if answer.lower() in yes_dict:
            shutil.rmtree("binaries/Community A-4E Binaries")

    with open("binaries/file_ids.json", "r") as f:
        txt = f.read()
        file_id_json = json.loads(txt)
        f.close()

        #size_downloaded = 0
        #files_downloaded = 0
        #total_files = count_files(file_id_json)

        #file_id_json["path"] = "binaries/Community A-4E Binaries"
        
        #download_files(file_id_json)
        file_downloader = FileDownloader(file_id_json, "binaries")
        file_downloader.count_files()
        if file_downloader.begin_download():
            copy_and_merge_files()
        else:
            print("Something went wrong with the download. Merge aborted.")


    

if __name__ == "__main__":
    main()
