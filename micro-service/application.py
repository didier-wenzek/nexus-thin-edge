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
    user = f'{device}_{random_string(5)}'
    password = random_string(20)

    command = f'./post-registration.sh {device} {user} {password}'
    res = os.system(command) 

    if res == 0:
        return f'{{"url": "https://my-ca.com", "user": "{user}", "pass": "{password}"}}'
    else:
        return f'{{"error": "{res}"}}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
