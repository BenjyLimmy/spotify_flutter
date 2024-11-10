import uuid
import bcrypt
from fastapi import FastAPI, HTTPException, APIRouter

from models.user import User
from pydantic_schemas.user_create import UserCreate
from database import db

router = APIRouter()

@router.post('/signup')
def signup_user(user: UserCreate):

    #check if user already exists in db
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(400, "User with the same email already exists")
    
    hashed_pw = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt(16))
    
    user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_pw)
    #add user to db
    db.add(user_db)
    db.commit()
    db.refresh(user_db) #refresh user object to get id
    return user_db