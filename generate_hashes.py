import hashlib
import os
import struct
import sys

BUFF_SIZE = 65536

def generate_hashes(files, root, fm_folder):
    header = """#pragma once
    #include <Windows.h>

    static WCHAR* files[] = {}

    static BYTE hashes[][32] = {}
    """

    file_string = "{"
    hash_string = "{\n"

    print("==== Hashes ====")

    for file in files:
        sha1 = hashlib.sha1()
        path = os.path.join(root, file)
        file_string += "L\"" + file + "\"" + ','
        f = open (path, 'rb')
        while True:
            data = f.read(BUFF_SIZE)
            if not data:
                break
            sha1.update(data)     
        f.close()
        
        print("File: {}, SHA1: {}".format(file, sha1.hexdigest()))

        digest = sha1.digest()

        hash_string += "\t{"

        for i in xrange(0, len(digest)):
            value = struct.unpack('B', digest[i])[0]
            hash_string += "0x{:02x}".format(value) + ','

        hash_string = hash_string[:-1]
        hash_string += "},\n"

    hash_string = hash_string[:-2]
    hash_string += "\n};"


    file_string= file_string[:-1]
    file_string += "};"

    header_file = open(os.path.join(fm_folder, "Hashes.h"), "w+")
    header_file.write(header.format(file_string, hash_string))
    header_file.close()

def normalise_file_endings(file):
    backup = file + "_"
    os.rename(file, file + "_")
    

    fileRead = open(file + "_", "rU")
    if fileRead:
        text = fileRead.read()
        fileRead.close()

        text = text.replace('\n', '\r\n')

        fileWrite = open(file, "wb+")
        if fileWrite:
            fileWrite.write(text)
            os.remove(file + "_")
            print("{} line endings normalised.".format(file))

        else:
            print("Error Occured in Write.")


    else:
        print("Error Occured in Read.")




def normalise_files_endings(files, root):
    for file in files:
        normalise_file_endings(os.path.join(root, file))



def main(files, root, fm_folder):
    normalise_files_endings(files, root)
    generate_hashes(files, root, fm_folder)

if __name__ == "__main__":
    files = ["entry.lua","A-4E-C.lua", "Cockpit\\Scripts\\EFM_Options.lua", "Entry\\Suspension.lua"]
    root = "A-4E-C"
    fm_folder = "A-4E-C\\ExternalFM\\FM"

    main(files, root, fm_folder)