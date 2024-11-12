from fastapi import FastAPI
from routes import auth
from models.base import Base
from database import engine

# Create FastAPI instance
app = FastAPI()
# Include auth router in app
app.include_router(auth.router, prefix='/auth')
# Create all tables in database
Base.metadata.create_all(bind=engine)