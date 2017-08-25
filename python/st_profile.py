#!/usr/bin/python3
from urllib2 import HTTPError
import urllib2
import base64
import json
import os

SERVER_ADDRESS = 'http://enterobase.warwick.ac.uk'
DATABASE = 'senterica' 
scheme = 'MLST_Achtman' 

def __create_request(request_str):

    request = urllib2.Request(request_str)
    base64string = base64.encodestring('%s:%s' % (API_TOKEN,'')).replace('\n', '')
    request.add_header("Authorization", "Basic %s" % base64string)
    return request

address = SERVER_ADDRESS + '/api/v2.0/%s/schemes?scheme_name=%s&limit=%d&only_fields=download_sts_link' %(DATABASE, scheme, 4000)

os.mkdir(scheme)
try:
    response = urllib2.urlopen(__create_request(address))
    data = json.load(response)
    for scheme_record in data['Schemes']:
        profile_link = scheme_record.get('download_sts_link', None)
        if profile_link:
           response = urllib2.urlopen(profile_link)
           with open(os.path.join(scheme, 'MLST-profiles.gz'), 'wb') as output_profile:
               output_profile.write(response.read())
except HTTPError as Response_error:
    print '%d %s. <%s>\n Reason: %s' %(Response_error.code,
                                                      Response_error.msg,
                                                      Response_error.geturl(),
                                                      Response_error.read())
