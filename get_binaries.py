import sys
import os
import gdown
import shutil
from zipfile import ZipFile

#Needs both of these for some weird reason.
import distutils
from distutils import dir_util


def main():
    url = "https://drive.google.com/uc?id=1r2cYJ4Dhlv4LUHG_6lazFy89kIf-JiBt"
    out = "binaries/bin.zip"

    yes_dict = {
        "y" : True,
        "yes": True,
        "yea": True
    }

    if os.path.exists("binaries/bin.zip"):
        answer = input("Binaries already exist redownload?\n")
        if answer.lower() in yes_dict:
            os.remove("binaries/bin.zip")
            gdown.download(url, out, quiet=False)
    else:
        gdown.download(url, out, quiet=False)

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
