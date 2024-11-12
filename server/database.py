from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Database Connection URL
DATABASE_URL = 'postgresql://postgres:Benjy123!@localhost:5432/flutterspotify'
# Create a database connection engine
engine = create_engine(DATABASE_URL)
# Create a session local
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Function to get database session
def get_db():
    db = SessionLocal()
    # Yield db session to be used in routes
    try:
        yield db
    # Close db session after use
    finally:
        db.close()