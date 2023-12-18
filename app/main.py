import os
import app.secrets as secrets

def handler(event, context):
    sec = secrets.get_secrets().get("Parameter", {})
    return {
        "statusCode": 200,
        # "body": f"${ssl.OPENSSL_VERSION}\r\n${ssl.OPENSSL_VERSION_NUMBER}\r\n${ssl.OPENSSL_VERSION_NUMBER}"
        "body": f"Hello, World! (From {sec.get('Value')})"
    }
