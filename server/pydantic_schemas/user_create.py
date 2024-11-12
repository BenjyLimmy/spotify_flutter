from pydantic import BaseModel

# User Model for Signup
class UserCreate(BaseModel):
    name: str
    email: str
    password: str