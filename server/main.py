from fastapi import FastAPI, HTTPException, Request
from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary
from sqlalchemy.orm import declarative_base
import uuid
import bcrypt


app = FastAPI()




# User Table
Base = declarative_base()
class User(Base):
    __tablename__ = "users"
    id = Column(TEXT, primary_key=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)


@app.post('/signup')
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

Base.metadata.create_all(bind=engine)