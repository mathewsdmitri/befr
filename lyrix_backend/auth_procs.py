import secrets
import string
import hashlib
import base64

def generate_random_string(length):
    possible = string.ascii_letters + string.digits
    result = ''
    for _ in range(length):
        result += result.join(secrets.choice(possible))
    return result

def sha256(plain):
    return hashlib.sha256(plain.encode()).digest()

def base64encode(input_bytes):
    encoded = base64.b64encode(input_bytes).decode('utf-8')
    return encoded.replace('=','').replace('+','-').replace('/','_')

codeVerifier = generate_random_string(60)
hashed = sha256(codeVerifier)
codeChallenge = base64encode(hashed)