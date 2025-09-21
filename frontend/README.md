# FlowSafe Mobile App 📱

<div align="center">
  <img src="../screenshots/mobile-app/dashboard.png" alt="FlowSafe Dashboard" width="300"/>
</div>

**FlowSafe** - Your comprehensive AI-powered health surveillance system that predicts, monitors, and prevents water-borne disease outbreaks with advanced analytics and emergency response capabilities.

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev/)
[![Analytics](https://img.shields.io/badge/fl__chart-0.68.0-blue.svg)](https://pub.dev/packages/fl_chart)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](../LICENSE)

## 🌟 Features

### 🚨 Emergency Reporting System *[New]*
- **Critical Health Incidents** - Immediate reporting of disease outbreaks, water contamination, and medical emergencies
- **Real-time Alert Distribution** - Instant notifications to health authorities and emergency responders
- **Severity Assessment** - Automated risk scoring with color-coded priority levels (Critical, High, Medium, Low)
- **Contact Management** - Direct integration with emergency services and health departments
- **Incident Tracking** - Complete audit trail from report to resolution with status updates
- **Geographic Emergency Mapping** - GPS-based incident location for rapid response coordination

### 📊 Comprehensive Health Data Collection Hub *[New]*
- **Field Survey Management** - Door-to-door household health surveys with demographic tracking and family composition analysis
- **Health Camp Data Collection** - Medical camp organization, patient statistics, and service delivery tracking
- **ASHA Worker Interface** - Specialized tools for community health workers with simplified data entry and progress tracking
- **Volunteer Data Collection** - Community volunteer interface for health data gathering and awareness campaigns
- **Clinic Data Integration** - Local health clinic data collection with patient management capabilities
- **Role-based Access Control** - Customized interfaces based on user type (ASHA, Volunteer, Clinic Staff, Community Members)

### 📈 Advanced Analytics Dashboard *[New]*
- **Interactive Charts & Graphs** - Real-time data visualization using fl_chart library with line, bar, and pie charts
- **Water Quality Trends** - Monthly pH levels, turbidity, and bacterial contamination tracking with trend analysis
- **Field Survey Analytics** - Completion rates, demographic analysis, and geographic distribution visualization
- **Health Indicator Tracking** - Progress monitoring for vaccination, sanitation, water access, and infrastructure
- **Performance Metrics** - Key performance indicators for health programs and interventions
- **Predictive Analytics** - AI-powered forecasting for disease outbreaks and resource planning

### 🤖 AI-Powered Health Assistant
- **Multilingual AI Chatbot** powered by Google Gemini with enhanced health query processing
- **Personalized health recommendations** based on location, symptoms, and collected health data
- **24/7 health query support** in multiple Indian languages with context-aware responses
- **Emergency Response Integration** - AI chatbot can escalate critical health concerns to emergency reporting system

### 📊 Disease Prediction & Alerts
- **Real-time risk assessment** for water-borne diseases (diarrhea, cholera, typhoid, hepatitis A, dysentery)
- **Location-based alerts** with village-level granularity and predictive modeling
- **Smart notifications** with color-coded risk zones (Green/Yellow/Red) and personalized recommendations
- **Outbreak Pattern Recognition** - Machine learning models for early detection and prevention

### 🗺️ Interactive Health Maps
- **Live risk visualization** with interactive maps and real-time data overlays
- **Water Quality Monitoring** - Interactive maps showing contamination sources and testing locations
- **Geofenced alerts** for your specific location with customizable radius settings
- **Satellite data integration** for environmental health monitoring and watershed analysis

### 👥 Multi-User Support *[Enhanced]*
- **ASHA/Health Workers** - Comprehensive field work interface, community monitoring, and specialized data collection tools
- **Community Volunteers** - Volunteer-specific interface with simplified workflows and progress tracking
- **Local Clinics** - Clinical data management, patient tracking, and service delivery monitoring
- **Rural Households** - Simple alerts, prevention tips, and emergency reporting capabilities
- **Health Officials** - Administrative dashboard with analytics and emergency coordination tools

### 💧 Water Quality Monitoring *[Enhanced]*
- **Real-time Water Testing** - IoT sensor integration with live data streaming and alerts
- **Manual Test Kit Support** - pH, turbidity, TDS, bacterial count with trend analysis and recommendations
- **Water Source Tracking** - Comprehensive monitoring of borewells, hand pumps, community wells with historical data
- **Interactive Analytics** - Charts showing water quality trends, safety level distribution, and testing activity
- **Contamination Mapping** - Geographic visualization of water quality issues and improvement tracking

### 📱 Core App Features *[Enhanced]*
- **Google OAuth Authentication** - Secure and seamless login with role-based access control
- **Advanced Profile Management** - User preferences, health history, and role-specific customization
- **Prescription Management** - Upload, track, and manage prescriptions with OCR text recognition
- **Comprehensive Health Check** - Symptom assessment, risk evaluation, and personalized recommendations
- **Smart Notification Center** - Customizable alert preferences with emergency escalation
- **Robust Offline Support** - Complete offline data collection, automatic sync, and conflict resolution

## 🛠️ Technology Stack

### Framework & Language
- **Flutter** 3.8.1 - Cross-platform mobile development
- **Dart** 3.8.1 - Programming language

### State Management & Architecture
- **Provider** 6.1.1 - State management
- **MVVM Architecture** - Clean separation of concerns
- **Service Layer** - API and business logic abstraction

### Key Dependencies
- **Google Sign-In** 6.1.5 - Authentication and OAuth integration
- **Google Generative AI** 0.4.7 - AI chatbot integration with emergency response capabilities
- **HTTP** 1.1.0 - API communication and data synchronization
- **fl_chart** 0.68.0 - Advanced analytics charts and data visualization
- **Geolocator** 14.0.2 - Location services and GPS tracking for emergency reporting
- **Flutter Map** 8.1.1 - Interactive maps with water quality overlays
- **Image Picker** 1.0.4 - Camera and gallery access for documentation
- **Flutter Secure Storage** 10.0.0 - Secure data storage for sensitive health information
- **Shared Preferences** 2.2.2 - Local data persistence and offline sync capabilities
- **Provider** 6.1.1 - State management for complex data flows

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / Xcode (for device testing)
- Google Maps API key
- Google OAuth credentials

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/aarogyarekha.git
   cd aarogyarekha/frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your configuration:
   ```env
   API_BASE_URL=http://localhost:8000/api/
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   GOOGLE_OAUTH_CLIENT_ID=your_google_oauth_client_id
   GEMINI_API_KEY=your_gemini_api_key
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point with theme configuration
├── config/                            # Configuration files
├── models/                            # Data models
│   ├── user_model.dart               # User profile and authentication data
│   ├── health_data_model.dart        # Health survey and medical data models
│   ├── water_quality_model.dart      # Water testing and monitoring data
│   ├── emergency_report_model.dart   # Emergency incident reporting data
│   └── alert_model.dart              # Alert and notification models
├── screens/                           # UI Screens
│   ├── auth/                         # Authentication screens
│   │   ├── login_page.dart           # Login with Google OAuth
│   │   └── register_page.dart        # User registration
│   ├── dashboard_screen.dart         # Main dashboard with analytics overview
│   ├── profile_screen.dart           # User profile management
│   ├── chatbot_screen.dart           # AI chatbot with emergency escalation
│   ├── risk_map_screen.dart          # Interactive maps with water quality data
│   ├── alerts_screen.dart            # Alert center and notifications
│   ├── health_check_screen.dart      # Symptom assessment
│   ├── notifications_screen.dart     # Push notification management
│   ├── settings_screen.dart          # App settings and preferences
│   ├── water_quality_dashboard_screen.dart  # Water quality analytics with charts
│   ├── water_quality_details_screen.dart    # Detailed water quality information
│   ├── water_quality_screen.dart            # Water quality data entry
│   ├── emergency_report_screen.dart         # Emergency incident reporting [NEW]
│   ├── health_data_collection_hub.dart     # Central hub for health data collection [NEW]
│   ├── field_survey_screen.dart            # Field survey data collection with analytics [NEW]
│   ├── health_camp_data_screen.dart        # Health camp management and statistics [NEW]
│   ├── asha_worker_screen.dart             # ASHA worker interface [NEW]
│   ├── volunteer_data_screen.dart          # Volunteer data collection interface [NEW]
│   └── clinic_data_screen.dart             # Local clinic data management [NEW]
├── services/                          # Business logic & API services
│   ├── api_service.dart              # Main API service with authentication
│   ├── auth_state.dart               # Authentication state management
│   ├── location_service.dart         # GPS location and geofencing services
│   ├── gemini_service.dart           # AI chatbot service with health intelligence
│   ├── health_prediction_service.dart # Disease prediction and risk assessment
│   ├── alerts_service.dart           # Alert management and distribution
│   ├── health_data_service.dart      # Health data collection and analytics [NEW]
│   ├── emergency_service.dart        # Emergency reporting and response [NEW]
│   ├── water_quality_service.dart    # Water quality monitoring and analysis
│   └── offline_sync_service.dart     # Offline data synchronization
├── widgets/                           # Reusable UI components
│   ├── custom_app_bar.dart           # Custom app bar with user context
│   ├── health_card.dart              # Health information display cards
│   ├── risk_indicator.dart           # Risk level visualization
│   ├── chart_widgets.dart            # Analytics chart components [NEW]
│   ├── emergency_widgets.dart        # Emergency reporting UI components [NEW]
│   ├── data_collection_widgets.dart  # Health data collection form components [NEW]
│   ├── chat_bubble.dart              # Chat interface components
│   ├── localized_text.dart           # Multilingual text support
│   └── main_navigation.dart          # Bottom navigation with role-based access
└── demo/                              # Demo and test files
    ├── mock_data.dart                # Sample data for testing
    └── test_scenarios.dart           # Testing scenarios and user flows
```

## 🔧 Configuration

### API Configuration
Update the API base URL in your `.env` file:
```env
API_BASE_URL=https://your-backend-domain.com/api/
```

### Maps Configuration
Add your Google Maps API key:
```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

### Authentication Setup
Configure Google OAuth:
```env
GOOGLE_OAUTH_CLIENT_ID=your_google_oauth_client_id
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Manual Testing
```bash
# Run on Android emulator
flutter run

# Run on iOS simulator
flutter run -d ios

# Run on physical device
flutter run -d [device_id]
```

## 🏗️ Build & Deployment

### Android Build
```bash
# Debug build
flutter build apk

# Release build
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

### iOS Build
```bash
# Debug build
flutter build ios

# Release build
flutter build ios --release
```

### Web Build (if supported)
```bash
flutter build web
```

## 🎨 UI/UX Guidelines

### Color Scheme
- **Primary**: `#2E7D8A` (Teal)
- **Secondary**: `#4CAF50` (Green)
- **Accent**: `#FF9800` (Orange)
- **Background**: `#F5F5F5` (Light Grey)
- **Text**: `#333333` (Dark Grey)

### Typography
- **Headers**: Poppins, Bold
- **Body**: Roboto, Regular
- **Captions**: Roboto, Light

### Design Principles
- **Accessibility First** - Support for screen readers and high contrast
- **Responsive Design** - Works on all screen sizes
- **Intuitive Navigation** - Clear information hierarchy
- **Consistent Branding** - Cohesive visual identity

## 📱 App Screens Overview

### 🏠 Dashboard
- Comprehensive health status overview with real-time analytics
- Risk indicators for your area with predictive modeling
- Quick actions (Health Check, Chatbot, Alerts, Emergency Reporting)
- Weather and environmental data integration
- Role-based interface customization

### 🚨 Emergency Reporting *[New]*
- Critical health incident reporting interface
- Severity assessment with automated risk scoring
- Real-time alert distribution to authorities
- GPS-based incident location tracking
- Contact management for emergency services
- Incident status tracking and resolution monitoring

### 📊 Health Data Collection Hub *[New]*
- Central navigation for all data collection activities
- Role-based access for ASHA workers, volunteers, and clinic staff
- Data collection statistics and progress tracking
- Quick access to field surveys, health camps, and emergency reporting
- Offline data collection capabilities with automatic sync

### 📋 Field Survey Management *[New]*
- Door-to-door household health surveys
- Demographic data collection and family composition tracking
- Infrastructure assessment (water, sanitation, electricity)
- Health status monitoring and vaccination tracking
- Survey analytics with completion rates and trend analysis

### 🏥 Health Camp Data Collection *[New]*
- Medical camp organization and patient statistics
- Service delivery tracking and resource management
- Patient demographics and treatment records
- Camp performance analytics and reporting
- Integration with local health systems

### 👩‍⚕️ ASHA Worker Interface *[New]*
- Specialized tools for community health workers
- Simplified data entry workflows
- Community health monitoring dashboard
- Progress tracking and performance metrics
- Direct communication with health authorities

### 🙋‍♂️ Volunteer Data Collection *[New]*
- Community volunteer interface for health data gathering
- Awareness campaign tracking and effectiveness measurement
- Simplified reporting tools for non-medical personnel
- Progress tracking and volunteer coordination
- Community engagement analytics

### 🏥 Clinic Data Management *[New]*
- Local health clinic data collection interface
- Patient management and service tracking
- Resource allocation and utilization monitoring
- Performance metrics and reporting
- Integration with district health systems

### 💧 Water Quality Dashboard *[Enhanced]*
- Interactive water quality analytics with advanced charts
- Real-time monitoring of pH levels, turbidity, and bacterial contamination
- Monthly and weekly trend analysis with predictive modeling
- Water source safety distribution visualization
- Testing activity monitoring and compliance tracking

### 🤖 AI Chatbot *[Enhanced]*
- Natural language health queries with emergency escalation
- Multilingual support (Hindi, English, regional languages)
- Personalized health recommendations based on collected data
- Symptom assessment with emergency response integration
- Context-aware responses using comprehensive health database

### 🗺️ Interactive Risk Map *[Enhanced]*
- Interactive map with risk zones and water quality overlays
- Real-time outbreak predictions with geographic visualization
- Location-based alerts with customizable radius settings
- Historical trend analysis and pattern recognition
- Water contamination source mapping

### 👤 Profile Management *[Enhanced]*
- User information and preferences with role-based customization
- Comprehensive health history and records
- Notification settings with emergency alert preferences
- Privacy and security options with data control
- Multi-role support for different user types

### 📋 Health Check *[Enhanced]*
- Comprehensive symptom assessment questionnaire
- Risk evaluation based on location and water quality data
- Personalized prevention tips and emergency recommendations
- Historical health data with trend analysis
- Integration with emergency reporting system

### 🔔 Smart Notifications *[Enhanced]*
- Disease outbreak alerts with severity-based prioritization
- Preventive health tips based on local conditions
- Weather-related health warnings with predictive analytics
- Community health updates and emergency broadcasts
- Customizable alert preferences with emergency escalation

## 🌍 Localization

### Supported Languages
- **English** (Primary)
- **Hindi** (हिंदी)
- **Bengali** (বাংলা)
- **Telugu** (తెలుగు)
- **Tamil** (தமிழ்)
- **Marathi** (मराठी)

### Adding New Languages
1. Create language files in `lib/l10n/`
2. Update `pubspec.yaml` with new locale
3. Run `flutter pub get`
4. Update UI strings to use localization

## 🔐 Security & Privacy

### Data Protection
- **Encrypted Storage** - Sensitive data stored securely
- **HTTPS Only** - All API communications encrypted
- **Token Management** - Secure authentication tokens
- **Privacy Controls** - User data preferences

### Permissions
- **Location** - For area-specific health alerts
- **Camera** - For prescription uploads
- **Storage** - For offline data caching
- **Notifications** - For health alerts

## 🐛 Troubleshooting

### Common Issues

**Build Errors**
```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

**Location Issues**
```bash
# Check permissions in device settings
# Ensure location services are enabled
```

**API Connection Problems**
```bash
# Verify backend is running
# Check .env configuration
# Ensure network connectivity
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the code style guidelines
4. Write tests for new features
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style
- Follow [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Use `flutter analyze` to check for issues
- Run `flutter format .` before committing

## 📚 Resources

### Flutter Documentation
- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)

### Project-Specific Resources
- [API Documentation](../docs/api.md)
- [Contributing Guidelines](../CONTRIBUTING.md)
- [Backend Setup](../aarogyarekha-backend/README.md)

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/aarogyarekha/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/aarogyarekha/discussions)
- **Email**: developers@aarogyarekha.in

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

---

<div align="center">
  <p><strong>AarogyaRekha</strong> - Drawing the Digital Line Between Health and Disease</p>
  <p>Made with ❤️ for India's Healthcare Future</p>
</div>
