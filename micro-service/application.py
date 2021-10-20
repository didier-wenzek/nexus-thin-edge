#!flask/bin/python
from flask import Flask, jsonify
import os
import random
import string

app = Flask(__name__)

def random_string(length):
    return ''.join(random.SystemRandom().choice(string.ascii_letters + string.digits) for _ in range(length))

# Hello world endpoint
@app.route('/')
def hello():
    return 'Registration service'

# Verify the status of the microservice
@app.route('/health')
def health():
    return '{ "status" : "UP" }'

# Verify the status of the microservice
@app.route('/register/<device>')
def register(device):
    host = 'pgw.38.qa.go.nexusgroup.com:8443'
    account = 'sag_te_di1_dc1'
    url = f'https://{host}/est/{account}/simpleenroll'
    user = f'user_{random_string(10)}'
    password = random_string(20)

    command = f'./post-registration.sh {device} {user} {password}'
    res = os.system(command) 

    if res == 0:
        return f'{{"url": "{url}", "user": "{user}", "pass": "{password}"}}'
    else:
        return f'{{"error": "{res}"}}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
