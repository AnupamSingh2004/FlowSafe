# FlowSafe 
### *Smart Health Surveillance and Early Warning System for Water-borne Diseases*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev/)
[![Django](https://img.shields.io/badge/Django-4.2-green.svg)](https://www.djangoproject.com/)
[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-blue.svg)](https://www.docker.com/)
[![Healthcare](https://img.shields.io/badge/Healthcare-AI%20Powered-red.svg)](https://www.who.int/)
[![AI/ML](https://img.shields.io/badge/AI%2FML-XGBoost-orange.svg)](https://xgboost.ai/)
[![Water Quality](https://img.shields.io/badge/Water%20Quality-IoT%20Ready-blue.svg)](https://www.who.int/news-room/fact-sheets/detail/drinking-water)

## Overview

FlowSafe is an AI-powered Smart Health Surveillance and Early Warning System specifically designed to detect, monitor, and prevent outbreaks of water-borne diseases in vulnerable communities, particularly in rural areas and tribal belts of the Northeastern Region (NER).

The system combines water quality monitoring, disease surveillance, community reporting, and educational modules to create a comprehensive solution for water-borne disease prevention including **Diarrhea, Cholera, Typhoid, Hepatitis A, and Dysentery**.

By integrating IoT sensors, mobile health reporting, and AI-based outbreak prediction, FlowSafe empowers health workers, community volunteers, and local governance bodies to take proactive measures before outbreaks occur.

## Demo Video



https://github.com/user-attachments/assets/587c3f94-a49d-4ed8-8263-d56318387a04


## Presentation

[Click here to view the presentation](https://docs.google.com/presentation/d/15ZrNp3PPfow25XWRmxWCd0ObyUBhTON5wkk3iI3HX6g/edit?usp=sharing)



## Screenshots

### Mobile App Interface

<div align="center">
  <img src="https://github.com/user-attachments/assets/9bd7cd2a-e412-499d-a02f-7d96af853772" alt="Settings" width="350" height="850"/>
  <img src="https://github.com/user-attachments/assets/b81ab416-1c93-4373-a9c2-ed2b17b0b093" alt="Prescriptions" width="350" height="850"/>
</div>

<div align="center">
  <img src="https://github.com/user-attachments/assets/d0103546-1e16-4297-84cf-e8ee47f8477e" alt="User Profile" width="350" height="850"/>
  <img src="https://github.com/user-attachments/assets/520ec360-8710-4df3-a4ed-e92d5df1c4b9" alt="Reports & Analytics" width="350" height="850"/>
</div>
<div align="center">
  <img src="https://github.com/user-attachments/assets/2d8bb1c3-4a90-4bca-9add-d9fac237326c" alt="AI Chatbot" width="350" height="850"/>
  <img src="https://github.com/user-attachments/assets/3bf5820f-bcd4-4546-acd3-d51e1d8e7078" alt="Satellite Intelligence" width="350" height="850"/>
</div>

<div align="center">
  <img src="https://github.com/user-attachments/assets/9c284055-607f-4a8a-a3a9-127fe76c3603" alt="Alert System" width="350" height="850"/>
  <img src="https://github.com/user-attachments/assets/8521e27c-7096-4bf9-bdf6-53c7a1ad915d" alt="Risk Map" width="350" height="850"/>
</div>

<div align="center">
  <img src="https://github.com/user-attachments/assets/acde075b-b754-48b2-a7f9-799d902ccc02" alt="Health Prediction" width="350" height="850"/>
  <img src="https://github.com/user-attachments/assets/7ee0cce0-99e7-473b-aae6-08a4a71739f5" alt="Dashboard Screen" width="350" height="850"/>
</div>









## Key Features

### Water Quality Monitoring
- **Real-time water testing** with IoT sensor integration
- **Manual test kit support** for pH, turbidity, TDS, bacterial count
- **Water source tracking** (Borewell, Hand Pump, Community Well, etc.)
- **Quality assessment** with color-coded indicators and treatment recommendations
- **GPS-based location tagging** for contamination source mapping

### Disease Surveillance & Early Warning
- **Water-borne disease tracking** (Diarrhea, Cholera, Typhoid, Hepatitis A)
- **AI-powered outbreak prediction** with risk scoring algorithms
- **Symptom correlation** with water source contamination
- **Patient demographics** and disease severity assessment
- **Automatic health authority alerts** for high-risk cases

### Educational & Awareness Modules
- **Interactive hygiene education** with multi-lesson format
- **Safe water practices** and purification methods training
- **Disease prevention techniques** and emergency response
- **Community health best practices** and traditional medicine integration
- **Progress tracking** for educational module completion

### Multilingual Support
- **6 Regional languages** including tribal languages (Hindi, Bengali, Assamese, Nepali, Manipuri)
- **Localized health content** with cultural sensitivity
- **Voice-based navigation** for low-literacy users
- **Community reporting** in preferred languages

### Offline Functionality
- **Offline data collection** for remote areas with poor connectivity
- **Automatic sync** when internet becomes available
- **Data persistence** with local storage and queue management
- **Sync status tracking** with detailed progress indicators

### Smart Alert System
- **Risk-based notifications** with automatic outbreak detection
- **Multi-channel alerts** to health workers and governance bodies
- **Community broadcast** for preventive measure announcements
- **Emergency contact integration** for rapid response

## Target Audience

| User Group | Purpose Served |
|------------|----------------|
|  **ASHA/ANM Workers** | Report water-borne disease cases, monitor water quality, and educate communities on prevention |
|  **Primary Health Centers (PHCs)** | Receive early outbreak alerts, track disease patterns, and coordinate rapid response |
|  **Rural & Tribal Communities** | Access multilingual health education, report water quality issues, and receive preventive care guidance |
|  **Community Volunteers** | Conduct water quality testing, report contamination, and support health surveillance activities |
|  **Local Governance Bodies** | Monitor district-level health trends, allocate resources, and implement preventive interventions |
|  **Water & Sanitation Departments** | Track water source contamination, prioritize infrastructure improvements, and ensure safe water supply |
|  **District Officials** | Evidence-based planning and resource allocation |

## Technology Stack

### Frontend (Mobile App)
- **Flutter** 3.8.1 - Cross-platform mobile development
- **Dart** - Programming language for Flutter
- **Google Maps API** - Interactive maps and location services
- **Firebase** - Authentication and real-time database

### Backend
- **Django** 4.2 - Web framework
- **Python** 3.11 - Backend programming
- **PostgreSQL** - Primary database
- **Redis** - Caching and session management
- **Celery** - Asynchronous task processing

### AI/ML & Prediction
- **XGBoost** - Water-borne disease prediction models
- **TensorFlow** - Epidemic pattern recognition
- **OpenCV** - Water quality image analysis
- **NumPy & Pandas** - Environmental data processing
- **Scikit-learn** - Risk assessment algorithms

### IoT & Water Monitoring
- **Arduino/ESP32** - Water quality sensors integration
- **pH Sensors** - Water acidity measurement
- **TDS Meters** - Total dissolved solids detection
- **Turbidity Sensors** - Water clarity assessment
- **Temperature Sensors** - Thermal monitoring

### Satellite Data & APIs
- **MODIS** - Water body monitoring and climate data
- **ISRO Bhuvan** - Water resources satellite imagery
- **OpenWeatherMap** - Rainfall and humidity data
- **Google Earth Engine** - Watershed analysis
- **NASA FIRMS** - Water contamination tracking

## Quick Start

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Python 3.11 or higher
- PostgreSQL 13 or higher
- Redis server
- Google Maps API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flowsafe.git
   cd flowsafe
   ```

2. **Backend Setup**
   ```bash
   cd flowsafe-backend
   
   # Create virtual environment
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   
   # Install dependencies
   pip install -r requirements.txt
   
   # Set up environment variables
   cp .env.example .env
   # Edit .env with your configuration
   
   # Run migrations
   python manage.py migrate
   
   # Start the server
   python manage.py runserver
   ```

3. **Disease Prediction Service**
   ```bash
   cd disease_prediction
   
   # Install dependencies
   pip install -r requirements.txt
   
   # Start the prediction service
   python start_server.sh
   ```

4. **Frontend Setup**
   ```bash
   cd frontend
   
   # Install dependencies
   flutter pub get
   
   # Set up environment variables
   cp .env.example .env
   # Add your API keys and configuration
   
   # Run the app
   flutter run
   ```

## Project Structure

```
aarogyarekha/
├── frontend/                 # Flutter mobile app
│   ├── lib/
│   │   ├── screens/         # UI screens
│   │   ├── services/        # API and business logic
│   │   ├── widgets/         # Reusable UI components
│   │   └── models/          # Data models
│   ├── android/             # Android configuration
│   ├── ios/                 # iOS configuration
│   └── assets/              # Images and static files
├── aarogyarekha-backend/    # Django backend
│   ├── authentication/     # User authentication
│   ├── prescriptions/      # Prescription management
│   ├── profile_page/       # User profiles
│   └── disease_prediction/ # ML prediction service
├── disease_prediction/      # Standalone prediction service
│   ├── models/             # ML models
│   ├── data/               # Training data
│   └── api/                # Prediction API
├── docs/                   # Documentation
├── screenshots/            # Application screenshots
└── README.md              # This file
```

## API Documentation

### Authentication Endpoints
- `POST /api/auth/login/` - User login
- `POST /api/auth/register/` - User registration
- `POST /api/auth/logout/` - User logout
- `POST /api/auth/google/` - Google OAuth login

### Water Quality & Disease Prediction Endpoints
- `POST /api/water-quality/report/` - Submit water quality test results
- `GET /api/water-quality/reports/` - Get water quality history
- `POST /api/predict/waterborne-disease/` - Get disease risk prediction
- `GET /api/disease-surveillance/area/{location}/` - Get area disease monitoring data
- `GET /api/alerts/waterborne/` - Get water-related health alerts
- `POST /api/alerts/mark-read/` - Mark alerts as read

### User Management Endpoints
- `GET /api/user/profile/` - Get user profile
- `PUT /api/user/profile/` - Update user profile
- `GET /api/user/prescriptions/` - Get user prescriptions
- `POST /api/user/prescriptions/` - Add new prescription

## Configuration

### Environment Variables

Create a `.env` file in the backend directory:

```env
# Database
DATABASE_URL=postgresql://username:password@localhost:5432/flowsafe

# Django
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1

# Google APIs
GOOGLE_MAPS_API_KEY=your-google-maps-api-key
GOOGLE_OAUTH_CLIENT_ID=your-google-oauth-client-id
GOOGLE_OAUTH_CLIENT_SECRET=your-google-oauth-client-secret

# Satellite Data APIs
SENTINEL_API_KEY=your-sentinel-api-key
MODIS_API_KEY=your-modis-api-key
ISRO_BHUVAN_API_KEY=your-isro-api-key

# Weather API
OPENWEATHER_API_KEY=your-openweather-api-key

# Redis
REDIS_URL=redis://localhost:6379/0
```

### Flutter Configuration

Create a `.env` file in the frontend directory:

```env
# API Base URL
API_BASE_URL=http://localhost:8000/api/


# Google OAuth
GOOGLE_OAUTH_CLIENT_ID=your-google-oauth-client-id
```

## Testing

### Backend Tests
```bash
cd flowsafe-backend
python manage.py test
```

### Frontend Tests
```bash
cd frontend
flutter test
```

### Integration Tests
```bash
cd frontend
flutter drive --target=test_driver/app.dart
```

## ML Model Training

### Water-borne Disease Prediction Model
```bash
cd disease_prediction
python train_model.py --data-path ./data/waterborne_disease_data.csv --model-output ./models/ --focus waterborne
```

### Water Quality Analysis
```bash
cd disease_prediction
python process_water_quality_data.py --region "Northeastern Region" --start-date 2023-01-01 --end-date 2023-12-31
```

## Deployment

### Backend Deployment (Docker)
```bash
cd flowsafe-backend
docker build -t flowsafe-backend .
docker run -p 8000:8000 flowsafe-backend
```

### Frontend Deployment
```bash
cd frontend
flutter build apk --release
flutter build ios --release
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style
- Follow [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) for Dart code
- Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/) for Python code
- Use meaningful commit messages

## Roadmap

### Phase 1 - Data Integration ✅
- [x] Satellite data collection pipeline
- [x] Disease history database
- [x] Climate data integration
- [x] Local health records API

### Phase 2 - AI Training ✅
- [x] ML model development
- [x] Outbreak prediction algorithms
- [x] Risk assessment models
- [x] Validation and testing

### Phase 3 - Application Development ✅
- [x] Flutter mobile app
- [x] Django backend API
- [x] Web dashboard for PHCs
- [x] AI chatbot integration

### Phase 4 - Pilot Deployment 🔄
- [ ] Select high-risk districts
- [ ] ASHA worker training
- [ ] Community engagement
- [ ] Feedback collection

### Phase 5 - Scale & Improve 📅
- [ ] Government partnership
- [ ] NGO collaboration
- [ ] Multi-state deployment
- [ ] Advanced ML features



## Benefits at a Glance

| Benefit | Impact |
|---------|--------|
| **Predict Before It Spreads** | Prevents outbreaks at early stages |
| **Empowers Grassroot Health Workers** | Reduces manual workload & improves focus |
| **Saves Medical Costs** | Cheaper than treating full-blown outbreaks |
| **Quick Community Awareness** | Smart alerts prevent panic and misinformation |
| **Evidence-Based Planning** | Satellite + AI combo gives strong backend support |

### Smart India Hackathon Achievement
**FlowSafe** was developed for the **Smart India Hackathon**, showcasing innovative solutions for water-borne disease prevention through AI, IoT sensors, and satellite technology. Our team collaborated intensively to create this comprehensive water quality monitoring and disease surveillance system that addresses critical water-related health challenges in India's Northeastern Region.

---

<div align="center">
  <h3>� "FlowSafe is not just an app — it's a guardian of water safety."</h3>
  <p><i>A smart water monitoring system that stands watch over your community's water sources, alerts you before contamination spreads, and empowers communities to protect their health — not after disease outbreaks, but before they begin.</i></p>
</div>

---

<div align="center">
  <p>Made with 💧 for India's Water Safety & Health Future</p>
  <p>
    <a href="https://github.com/yourusername/flowsafe/issues">Request Feature</a>
  </p>
</div>
