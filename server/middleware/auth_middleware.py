import os
from fastapi import HTTPException, Header
import jwt

# Helper function to retrieve the public key from environment variables
def get_public_key():
    return os.getenv("PUBLIC_KEY").replace('\\n', '\n')

# Helper function to retrieve the private key from environment variables (if needed elsewhere)
def get_private_key():
    return os.getenv("PRIVATE_KEY").replace('\\n', '\n')

# Middleware function for authenticating requests using the 'x-auth-token' header
def auth_middleware(x_auth_token: str = Header()):
    try:
        # Ensure the token exists in the request header
        if not x_auth_token:
            raise HTTPException(401, 'No auth token, access denied.')
        
        # Decode and verify the token using the public key
        verified_token = jwt.decode(x_auth_token, get_public_key(), algorithms=['RS256'])

        # If decoding fails or the token is invalid, raise an exception
        if not verified_token:
            raise HTTPException(401, 'Token verification failed, authorisation denied.')
        
        # Extract the user ID ('id') from the verified token
        uid = verified_token.get('id')

        # Return a dictionary containing the user ID and token for further use
        return {'uid': uid, 'token': x_auth_token}
        
    except jwt.PyJWTError:
        # Handle any errors related to token decoding or verification
        raise HTTPException(401, 'Token invalid, authorisation denied.')
