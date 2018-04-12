#!/usr/bin/env python3

import urllib.request
import urllib.error
import requests
import re
import sys
import time
from pytube import YouTube

def getPlaylistPage(url):
    try:
        yTUBE = urllib.request.urlopen(url).read()
        return str(yTUBE)
    except urllib.error.URLError as e:
        print(e.reason)
        exit(1)

def getPlaylistID(url):
    if 'list=' in url:
        eq_idx = url.index('=') + 1
        pl_id = url[eq_idx:]
        if '&' in url:
            amp = url.index('&')
            pl_id = url[eq_idx:amp]
        return pl_id   
    else:
        print(url, "is not a youtube playlist.")
        exit(1)

def PrepareUrl(vid_urls):
    final_urls = []
    for vid_url in vid_urls:
        url_amp = len(vid_url)
        if '&' in vid_url:
            url_amp = vid_url.index('&')
        final_urls.append('http://www.youtube.com/' + vid_url[:url_amp])
    return final_urls

def getPlaylistVideoUrls(page, url):
    playlist_id = getPlaylistID(url)

    vid_url_pattern = re.compile(r'watch\?v=\S+?list=' + playlist_id)
    vid_url_matches = list(set(re.findall(vid_url_pattern, page)))

    if vid_url_matches:
        final_vid_urls = PrepareUrl(vid_url_matches)
        print("Found",len(final_vid_urls),"videos in playlist.")
        downloadPlaylist(final_vid_urls)
        return final_vid_urls
    else:
        print('No videos found.')
        exit(1)

def downloadPlaylist(vid_urls):
        for url in vid_urls:
            yt = YouTube(url)
            yt.streams.first().download()
            print(yt.title)

url = input("url: ")
playlist_page = getPlaylistPage(url)
vid_urls_in_playlist = getPlaylistVideoUrls(playlist_page, url)
