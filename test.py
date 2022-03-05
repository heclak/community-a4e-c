import os,requests
import sys
def download(url, filename):
    get_response = requests.get(url,stream=True)

    if get_response.status_code >= 400:
        raise Exception("Status code: {}".format(get_response.status_code))

    with open(filename, 'wb') as f:
        for chunk in get_response.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)

def get_size(url):
    headers = requests.head(url).headers
    return headers


url = "https://drive.google.com/uc?id=1PERkRxUciIDvky2sXm4FmykQzOXn6asb"

download(url, "test.pdf")