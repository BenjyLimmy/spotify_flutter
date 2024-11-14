# 🎶 Spotify Clone using Flutter

This project is a **Spotify** clone built using **Flutter**, offering a seamless music streaming experience. It incorporates a variety of modern tools and technologies to provide a robust, scalable, and efficient app for browsing, searching, and streaming music. This application demonstrates how to build a full-stack music app with Flutter for the frontend, FastAPI for the backend, and PostgreSQL for the database, along with Hive for local storage and Cloudinary for audio management.

---

## 🔧 Technologies Used

### Frontend:
- **Flutter**: A powerful framework for building cross-platform applications, providing a smooth and rich user experience across Android and iOS.
- **Riverpod**: A modern and flexible state management solution for managing app states and dependencies in Flutter.
  
### Backend:
- **FastAPI**: A high-performance web framework for building APIs with Python, chosen for its speed and ease of use in developing RESTful services.
- **PostgreSQL**: A robust and scalable relational database used to store user data, playlists, and music-related information.

### Storage and Media:
- **Hive**: A lightweight, fast, and secure key-value store used for local data storage within the app.
- **Cloudinary**: A cloud-based solution used for storing and managing audio files, providing features like file delivery and transformation.

---

## 📦 Installation

To get started with the **Spotify Clone** app, follow the instructions below to set up the project on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed on your system:
- **Flutter**: The Flutter SDK installed. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **Python**: Python 3.7+ for running the backend. Install it from [Python.org](https://www.python.org/downloads/).
- **PostgreSQL**: PostgreSQL installed and running locally. [PostgreSQL installation guide](https://www.postgresql.org/download/).
- **Cloudinary Account**: Create an account on [Cloudinary](https://cloudinary.com/) for managing audio files.

### 1. Clone the Repository
* Start by cloning the repository to your local machine:
```bash
git clone https://github.com/BenjyLimmy/spotify_flutter.git
cd spotify_flutter
```

### 2. Set Up the Backend (FastAPI)

#### A. Initial Setup
* Navigate to the backend directory:
```bash
cd server
```

* Create and activate a virtual environment:
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# For Unix/macOS
source venv/bin/activate
# For Windows
venv\Scripts\activate
```

#### B. Install Dependencies
* Install required Python packages:
```bash
pip install fastapi uvicorn sqlalchemy psycopg2-binary python-dotenv python-multipart
```

* Key dependencies:
  * fastapi
  * uvicorn
  * sqlalchemy
  * psycopg2-binary
  * python-dotenv
  * python-multipart
  * pydantic
  * asyncpg
  * passlib
  * python-jose
  * bcrypt

#### C. Configuration
* Configure your PostgreSQL database:
  * Create a `.env` file in the backend directory
  * Add your credentials:
```plaintext
DATABASE_URL=postgresql://username:password@localhost:5432/dbname
SECRET_KEY=your_secret_key
```

#### D. Start Backend Server
* Run the FastAPI backend:
```bash
fastapi dev main.py
```
* The backend API will be available at `http://localhost:8000`

### 3. Set Up the Frontend (Flutter)

#### A. Navigate to Client Directory
* Change to the client directory:
```bash
cd client
```

#### B. Flutter Setup
* Install Flutter dependencies:
```bash
flutter pub get
```

#### C. Configure Cloudinary
* Create `lib/config.dart` and add:
```dart
class Config {
    static const String cloudinaryUrl = "YOUR_CLOUDINARY_URL";
}
```

#### D. Launch Application
* Run the Flutter app:
```bash
flutter run
```

### 4. Database Configuration

#### A. Database Setup
* Import the database schema:
```bash
psql -U your_username -d your_database -f backend/schema.sql
```

#### B. Schema Configuration
* Ensure PostgreSQL instance is configured with:
  * User authentication tables
  * Music management schemas
  * Required indexes and constraints

### 5. Additional Configuration Requirements

#### A. Database Checklist
- [ ] PostgreSQL server installed and running
- [ ] Database created and accessible
- [ ] Schema successfully imported
- [ ] User permissions configured

#### B. Backend Checklist
- [ ] Virtual environment activated
- [ ] All Python dependencies installed
- [ ] Environment variables set
- [ ] API running successfully

#### C. Frontend Checklist
- [ ] Flutter SDK installed
- [ ] Dependencies resolved
- [ ] Cloudinary configuration complete
- [ ] Development environment ready

#### D. External Services
- [ ] Cloudinary account created
- [ ] API keys generated and configured
- [ ] Storage buckets set up
