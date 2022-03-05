import sys
import os
import requests
from ftplib import FTP

import shutil
from zipfile import ZipFile
import threading
import math

#Needs both of these for some weird reason.
import setuptools

import requests
import json

yes_dict = {
        "y" : True,
        "yes": True,
        "yea": True
    }

def download(url, filename, silent=True):
    get_response = requests.get(url,stream=True)

    if get_response.status_code >= 400:
        raise Exception("Status code: {}".format(get_response.status_code))

    downloaded = 0.0

    with open(filename, 'wb') as f:
        for chunk in get_response.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)

                if not silent:
                    downloaded += 1024.0
                    print("\rDownloaded {} MB               ".format(downloaded/1.0e6))

def fetch_id_json():
    json_generator_data = {
        'id' : '1i4xYe-Y3xNvkP4R1vBDZLz7o5wcDs6bT'
    }
    json_generator_url = "https://script.google.com/macros/s/AKfycbwQVkMXJMgExfgR94tIgsYEHV5l6PaD4cLrO_Y3jHS1hxGAU1j6UnmTHhKWWUVRvCbl6A/exec"

    result = requests.get(json_generator_url, allow_redirects=True, params=json_generator_data)
    
    with open("binaries/file_ids.json", "w+") as f:
        f.write(result.text)
        f.close()

    #id_json = json.loads(result.text)
    #return id_json

class DownloadProgress:
    def __init__(self, name, max_size):
        self.size = 0.0
        self.size_mb = 0
        self.max_size = int(float(max_size)/1.0e6)

        self.file = open(name, "wb")

        if self.file == None:
            raise FileNotFoundError

    def __del__(self):
        self.file.close()

    def write(self, data):
        self.file.write(data)
        self.size += float(len(data))
        newsize = int(self.size / 1.0e6)
        
        if newsize != self.size_mb:
            sys.stdout.write("\rDownloaded: {} MB / {} MB               ".format(newsize,self.max_size))
            self.size_mb = newsize

def download_from_ftp(url, out):
    ftp = FTP(url)
    ftp.login()


    path = "A4EBinaries.zip"

    size = ftp.size(path)

    current_download = DownloadProgress(out, size)

    with open(out, 'wb') as f:
        ftp.retrbinary('RETR {}'.format(path), current_download.write)
        f.close()

def old_download_method():
    url = 'vps620008.ovh.net'
    out = "binaries/bin.zip"
    
    

    if not os.path.exists("binaries"):
        os.mkdir("binaries")

    if os.path.exists("binaries/bin.zip"):
        answer = input("Binaries already exist redownload?\n")
        if answer.lower() in yes_dict:
            os.remove("binaries/bin.zip")
            download_from_ftp(url,out)
    else:
        download_from_ftp(url, out)

    
    print("Extracting...")
    shutil.unpack_archive("binaries/bin.zip", "binaries")
    print("Merging...")
    print(os.listdir('binaries'))
    if os.path.exists("binaries/Community A-4E Binaries"):

        setuptools.distutils.dir_util.copy_tree("binaries/Community A-4E Binaries", "A-4E-C")
        print("Removing Extracted Directories...")
        shutil.rmtree("binaries/Community A-4E Binaries")
        print("Done.")
    else:
        print("Directory not found")


def create_download_link(id):
    return "https://drive.google.com/uc?id=" + id




class FileDownloader:
    def __init__(self, root, path):
        self.root = root

        self.root["path"] = path + "/" + self.root["foldername"]


        self.size_downloaded = 0
        self.files_downloaded = 0
        self.files_existing = 0
        self.total_files = 0
        self.file_queue = []
        self.download_size = 0

    def begin_download(self):

        self.threads = []

        if not os.path.exists(self.root["path"]):
            os.mkdir(self.root["path"])

        self.create_folders()

        #for dir in self.root["folders"]:
            #dir["path"] = self.root["path"] + "/" + dir["foldername"]

            #self.threads.append(threading.Thread(target=self.download_files, args=(dir,)))
            #self.threads[-1].start()

        for i in range(4):
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

            for file in dir["files"]:
                self.download_size += file["size"]

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
                    "size" : file["size"]
                })
                #pass #print(file["fileID"])

            

            for folder in dir["folders"]:
                folder["path"] = path + "/" + folder["foldername"]
                folder_stack.append(folder)

        self.file_queue = sorted(self.file_queue, key=lambda item : item["size"])

    def downloader_loop(self):
        while self.file_queue:
            self.download_files()

    def download_files(self):

        if self.file_queue:
            file = self.file_queue.pop()


            if not os.path.exists(file["path"]):
                #try:
                    #gdd.download_file_from_google_drive(file_id=file["url"], dest_path=file["path"], showsize=True)
                download(file["url"], file["path"])
                #except Exception as e:
                    #print("\nError ({}): requeuing file {}...".format(type(e).__name__, file["path"]))
                    #self.file_queue.append(file)
                    #return

                self.size_downloaded += os.path.getsize(file["path"])
                self.files_downloaded += 1

                percent = float(self.size_downloaded) / float(self.download_size)

                n = 20.0
                nbar = int(percent * n)
                nspace = int((1.0 - percent) * n)

                bar = "\r{} files downloaded. {:.2f}% ".format(self.files_downloaded, percent*100) + "[" + nbar*"█" + nspace*" " + "]                 "
                sys.stdout.write(bar)
                #sys.stdout.write("\r{}/{} files downloaded totaling {}/{} MB      ".format(self.files_downloaded, self.total_files, int(self.size_downloaded / 1e6), int(self.download_size / 1e6)))
                
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

    use_old_method = True

    if use_old_method:
        old_download_method()
    else:
        main()
