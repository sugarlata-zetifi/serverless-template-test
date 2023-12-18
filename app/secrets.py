import os
import urllib3
import json


def get_secrets():
    http = urllib3.PoolManager()
    
    headers = {"X-Aws-Parameters-Secrets-Token": os.environ.get('AWS_SESSION_TOKEN')}
    
    secrets_extension_http_port = "2773"
    
    secrets_extension_endpoint = "http://localhost:" + \
    secrets_extension_http_port + \
    "/systemsmanager/parameters/get/?withDecryption=true&name=" + \
    "ZETIFI_LOCATION"
  
    resp = http.request(
    "GET",
    secrets_extension_endpoint,
    headers=headers
    )
    print('data', resp.data)
    
    secrets = json.loads(resp.data)
    
    return secrets

