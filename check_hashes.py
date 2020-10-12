import hashlib
import os
import sys

BUFF_SIZE = 65536

def main(files, useroot):
    if (len(files) == 0):
        print("Please supply files...")
        return

    root = "A-4E-C"
    fm_folder = "A-4E-C/ExternalFM/FM"


    print("==== Hashes ====")

    for file in files:
        sha1 = hashlib.sha1()
        path = file
        if ( useroot ):
            path = os.path.join(root, file)
        f = open (path, 'rb')
        while True:
            data = f.read(BUFF_SIZE)
            if not data:
                break
            sha1.update(data)     
        f.close()
        
        print("File: {}, SHA1: {}".format(file, sha1.hexdigest()))


if __name__ == "__main__":
    args = sys.argv[1:]

    files = []

    useRoot = False
    for arg in args:
        if arg == "--use_root":
            useRoot = True
        else:
            files.append(arg)
    main(files, useRoot)