from pydantic import BaseModel

# User Model for Login
class UserLogin(BaseModel):
    email: str
    password: str