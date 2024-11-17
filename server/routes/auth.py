import uuid
import bcrypt
from fastapi import Depends, FastAPI, HTTPException, APIRouter, Header

from database import get_db
from middleware.auth_middleware import get_private_key, get_public_key, auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from sqlalchemy.orm import Session
import jwt
from pydantic_schemas.user_login import UserLogin
from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()


router = APIRouter()

@router.post('/signup', status_code= 201)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):

    # Check if user already exists in db
    user_db = db.query(User).filter(User.email == user.email).first()

    # If user exists
    if user_db:
        # Throw error
        raise HTTPException(400, "User with the same email already exists")
    # If user does not exist then signup user
    else:
        # Hash user password with salting
        hashed_pw = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt(16))
        
        # Create new user with provided details
        user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_pw)
        # Add user to db
        db.add(user_db)
        db.commit()
        # Refresh User object to refresh User attributes
        db.refresh(user_db) 
        return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    # Check if user with same email already exists
    user_db = db.query(User).filter(User.email == user.email).first()

    # If user does not exist
    if not user_db:
        # Throw error
        raise HTTPException(400, 'User with this email does not exist!')

    # Check if password matching or not
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)
    
    # If password match, return User instance
    if is_match:
        token = jwt.encode({'id': user_db.id}, get_private_key(), algorithm='RS256')
        
        return {'token': token, 'user': user_db}
    # Throw error for incorrect password
    else:
        raise HTTPException(400, 'Incorrect password.')
    
@router.get('/')
def get_current_user(db: Session = Depends(get_db), user_dict: dict = Depends(auth_middleware)):
    # Use auth_middleware to validate the token and extract user information (user id)
    # The token and user id are passed as a dictionary (user_dict)

    # Query the database for the user with the extracted user id
    user = db.query(User).filter(User.id == user_dict['uid']).first()

    # If no user is found in the database, raise a 404 error
    if not user:
        raise HTTPException(404, 'User not found.')
    
    # Return the user information
    return user

        

    
