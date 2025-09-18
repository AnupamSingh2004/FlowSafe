import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  String _currentLanguage = 'English';
  String _currentLocale = 'en';

  String get currentLanguage => _currentLanguage;
  String get currentLocale => _currentLocale;
  Locale get locale => Locale(_currentLocale);

  final Map<String, String> _supportedLanguages = {
    'English': 'en',
    'हिंदी': 'hi',
    'বাংলা': 'bn',
    'অসমীয়া': 'as',
    'नेपाली': 'ne',
    'मणिपुरी': 'mni',
  };

  Map<String, String> get supportedLanguages => _supportedLanguages;

  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('selected_language') ?? 'English';
      if (_supportedLanguages.containsKey(savedLanguage)) {
        _currentLanguage = savedLanguage;
        _currentLocale = _supportedLanguages[savedLanguage]!;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> setLanguage(String language) async {
    if (_supportedLanguages.containsKey(language)) {
      _currentLanguage = language;
      _currentLocale = _supportedLanguages[language]!;
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_language', language);
      } catch (e) {
        print('Error saving language preference: $e');
      }
      
      notifyListeners();
    }
  }

  String translate(String key) {
    final languageCode = _currentLocale;
    return _translations[languageCode]?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'app_name': 'FlowSafe',
      'water_quality_monitoring': 'Water Quality Monitoring',
      'disease_surveillance': 'Disease Surveillance',
      'hygiene_education': 'Hygiene & Disease Prevention',
      'community_health_reporting': 'Community Health Reporting',
      'education_modules': 'Health Education',
      'current_location': 'Current Location',
      'water_source': 'Water Source',
      'water_quality_overview': 'Water Quality Overview',
      'recent_alerts': 'Recent Alerts',
      'water_sources': 'Water Sources',
      'water_quality_trends': 'Water Quality Trends',
      'ph_level': 'pH Level',
      'turbidity': 'Turbidity',
      'chlorine': 'Chlorine',
      'dissolved_oxygen': 'Dissolved Oxygen',
      'temperature': 'Temperature',
      'safe': 'Safe',
      'moderate': 'Moderate',
      'poor': 'Poor',
      'critical': 'Critical',
      'submit_report': 'Submit Report',
      'patient_details': 'Patient Details',
      'symptoms': 'Symptoms',
      'severity': 'Severity',
      'location': 'Location',
      'attach_photo': 'Attach Photo',
      'take_photo': 'Take Photo',
      'select_from_gallery': 'Select from Gallery',
      'diarrhea': 'Diarrhea',
      'fever': 'Fever',
      'vomiting': 'Vomiting',
      'dehydration': 'Dehydration',
      'hand_washing': 'Hand Washing',
      'safe_water': 'Safe Water',
      'food_safety': 'Food Safety',
      'prevention_tips': 'Prevention Tips',
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      'language': 'Language',
      'notifications': 'Notifications',
      'about': 'About',
      'help': 'Help',
      'contact': 'Contact',
      'version': 'Version',
      'terms': 'Terms & Conditions',
      'privacy': 'Privacy Policy',
      'back': 'Back',
      'save': 'Save',
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      
      // SMS Integration
      'sms_dashboard': 'SMS Dashboard',
      'sms_reports': 'SMS Reports',
      'send_sms_alert': 'Send SMS Alert',
      'sms_templates': 'SMS Templates',
      
      // Offline Sync
      'offline_sync': 'Offline Sync',
      'connection_status': 'Connection Status',
      'pending_reports': 'Pending Reports',
      'sync_now': 'Sync Now',
      'last_sync': 'Last Sync',
      'storage_info': 'Storage Information',
      
      // Health Authority Dashboard
      'health_authority_dashboard': 'Health Authority Dashboard',
      'outbreak_alerts': 'Outbreak Alerts',
      'resource_allocation': 'Resource Allocation',
      'district_overview': 'District Overview',
      
      // General Terms
      'online': 'Online',
      'offline': 'Offline',
      'urgent': 'Urgent',
      'processed': 'Processed',
      'pending': 'Pending',
      'health_and_safety': 'Health & Safety',
    },
    'hi': {
      'app_name': 'फ्लोसेफ',
      'water_quality_monitoring': 'जल गुणवत्ता निगरानी',
      'disease_surveillance': 'रोग निगरानी',
      'hygiene_education': 'स्वच्छता और रोग रोकथाम',
      'community_health_reporting': 'सामुदायिक स्वास्थ्य रिपोर्टिंग',
      'education_modules': 'स्वास्थ्य शिक्षा',
      'current_location': 'वर्तमान स्थान',
      'water_source': 'जल स्रोत',
      'water_quality_overview': 'जल गुणवत्ता अवलोकन',
      'recent_alerts': 'हाल की चेतावनियां',
      'water_sources': 'जल स्रोत',
      'water_quality_trends': 'जल गुणवत्ता रुझान',
      'ph_level': 'पीएच स्तर',
      'turbidity': 'टर्बिडिटी',
      'chlorine': 'क्लोरीन',
      'dissolved_oxygen': 'घुलित ऑक्सीजन',
      'temperature': 'तापमान',
      'safe': 'सुरक्षित',
      'moderate': 'मध्यम',
      'poor': 'खराब',
      'critical': 'गंभीर',
      'submit_report': 'रिपोर्ट जमा करें',
      'patient_details': 'मरीज़ का विवरण',
      'symptoms': 'लक्षण',
      'severity': 'गंभीरता',
      'location': 'स्थान',
      'attach_photo': 'फोटो संलग्न करें',
      'take_photo': 'फोटो लें',
      'select_from_gallery': 'गैलरी से चुनें',
      'diarrhea': 'दस्त',
      'fever': 'बुखार',
      'vomiting': 'उल्टी',
      'dehydration': 'निर्जलीकरण',
      'hand_washing': 'हाथ धोना',
      'safe_water': 'सुरक्षित पानी',
      'food_safety': 'खाद्य सुरक्षा',
      'prevention_tips': 'रोकथाम के सुझाव',
      'home': 'होम',
      'profile': 'प्रोफाइल',
      'settings': 'सेटिंग्स',
      'logout': 'लॉग आउट',
      'language': 'भाषा',
      'notifications': 'सूचनाएं',
      'about': 'के बारे में',
      'help': 'मदद',
      'contact': 'संपर्क',
      'version': 'संस्करण',
      'terms': 'नियम और शर्तें',
      'privacy': 'गोपनीयता नीति',
      'back': 'वापस',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'ok': 'ठीक है',
      'yes': 'हां',
      'no': 'नहीं',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      
      // SMS Integration
      'sms_dashboard': 'SMS डैशबोर्ड',
      'sms_reports': 'SMS रिपोर्ट',
      'send_sms_alert': 'SMS अलर्ट भेजें',
      'sms_templates': 'SMS टेम्प्लेट',
      
      // Offline Sync
      'offline_sync': 'ऑफलाइन सिंक',
      'connection_status': 'कनेक्शन स्थिति',
      'pending_reports': 'लंबित रिपोर्ट',
      'sync_now': 'अभी सिंक करें',
      'last_sync': 'अंतिम सिंक',
      'storage_info': 'संग्रहण जानकारी',
      
      // Health Authority Dashboard
      'health_authority_dashboard': 'स्वास्थ्य प्राधिकरण डैशबोर्ड',
      'outbreak_alerts': 'प्रकोप चेतावनी',
      'resource_allocation': 'संसाधन आवंटन',
      'district_overview': 'जिला अवलोकन',
      
      // General Terms
      'online': 'ऑनलाइन',
      'offline': 'ऑफलाइन',
      'urgent': 'तुरंत',
      'processed': 'प्रक्रिया की गई',  
      'pending': 'लंबित',
      'health_and_safety': 'स्वास्थ्य और सुरक्षा',
    },
    'bn': {
      'app_name': 'ফ্লোসেফ',
      'water_quality_monitoring': 'পানির গুণমান নিরীক্ষণ',
      'disease_surveillance': 'রোগ নিরীক্ষণ',
      'hygiene_education': 'স্বাস্থ্যবিধি ও রোগ প্রতিরোধ',
      'community_health_reporting': 'কমিউনিটি স্বাস্থ্য প্রতিবেদন',
      'education_modules': 'স্বাস্থ্য শিক্ষা',
      'current_location': 'বর্তমান অবস্থান',
      'water_source': 'পানির উৎস',
      'submit_report': 'প্রতিবেদন জমা দিন',
      'patient_details': 'রোগীর বিবরণ',
      'symptoms': 'লক্ষণ',
      'severity': 'তীব্রতা',
      'location': 'অবস্থান',
      'diarrhea': 'পাতলা পায়খানা',
      'fever': 'জ্বর',
      'vomiting': 'বমি',
      'dehydration': 'পানিশূন্যতা',
      'hand_washing': 'হাত ধোয়া',
      'safe_water': 'নিরাপদ পানি',
      'food_safety': 'খাদ্য নিরাপত্তা',
      'prevention_tips': 'প্রতিরোধমূলক পরামর্শ',
    },
    'as': {
      'app_name': 'ফ্লৌছেফ',
      'water_quality_monitoring': 'পানীৰ গুণগত নিৰীক্ষণ',
      'disease_surveillance': 'ৰোগ নিৰীক্ষণ',
      'hygiene_education': 'স্বাস্থ্যবিধি আৰু ৰোগ প্ৰতিৰোধ',
      'community_health_reporting': 'সমাজ স্বাস্থ্য প্ৰতিবেদন',
      'education_modules': 'স্বাস্থ্য শিক্ষা',
      'current_location': 'বৰ্তমান অৱস্থান',
      'water_source': 'পানীৰ উৎস',
      'submit_report': 'প্ৰতিবেদন দাখিল কৰক',
      'patient_details': 'ৰোগীৰ বিৱৰণ',
      'symptoms': 'লক্ষণ',
      'severity': 'তীব্রতা',
      'location': 'অৱস্থান',
      'diarrhea': 'পনীয়া শৌচ',
      'fever': 'জ্বৰ',
      'vomiting': 'বমি',
      'dehydration': 'পানীশূন্যতা',
      'hand_washing': 'হাত ধোৱা',
      'safe_water': 'নিৰাপদ পানী',
      'food_safety': 'খাদ্য নিৰাপত্তা',
      'prevention_tips': 'প্ৰতিৰোধমূলক পৰামৰ্শ',
    },
    'ne': {
      'app_name': 'फ्लोसेफ',
      'water_quality_monitoring': 'पानीको गुणस्तर निगरानी',
      'disease_surveillance': 'रोग निगरानी',
      'hygiene_education': 'स्वच्छता र रोग रोकथाम',
      'community_health_reporting': 'सामुदायिक स्वास्थ्य प्रतिवेदन',
      'education_modules': 'स्वास्थ्य शिक्षा',
      'current_location': 'हालको स्थान',
      'water_source': 'पानीको स्रोत',
      'submit_report': 'प्रतिवेदन पेश गर्नुहोस्',
      'patient_details': 'बिरामीको विवरण',
      'symptoms': 'लक्षणहरू',
      'severity': 'गम्भीरता',
      'location': 'स्थान',
      'diarrhea': 'झाडापखाला',
      'fever': 'ज्वरो',
      'vomiting': 'बान्ता',
      'dehydration': 'निर्जलीकरण',
      'hand_washing': 'हात धुने',
      'safe_water': 'सुरक्षित पानी',
      'food_safety': 'खाद्य सुरक्षा',
      'prevention_tips': 'रोकथामका सुझावहरू',
    },
    'mni': {
      'app_name': 'ꯐ꯭ꯂꯣꯁꯦꯐ',
      'water_quality_monitoring': 'ꯏꯁꯤꯡꯒꯤ ꯃꯒꯨꯟ ꯌꯦꯡꯁꯤꯅꯕꯥ',
      'disease_surveillance': 'ꯂꯥꯏꯅꯥ ꯌꯦꯡꯁꯤꯅꯕꯥ',
      'hygiene_education': 'ꯁꯦꯡꯅꯕꯥ ꯑꯃꯁꯨꯡ ꯂꯥꯏꯅꯥ ꯊꯤꯡꯖꯤꯅꯕꯥ',
      'community_health_reporting': 'ꯈꯨꯟꯅꯥꯏꯒꯤ ꯍꯀꯁꯦꯜ ꯔꯤꯄꯣꯔꯠ',
      'education_modules': 'ꯍꯀꯁꯦꯜ ꯇꯝꯄꯥꯛ',
      'current_location': 'ꯍꯧꯖꯤꯛꯀꯤ ꯃꯐꯝ',
      'water_source': 'ꯏꯁꯤꯡꯒꯤ ꯃꯐꯝ',
      'submit_report': 'ꯔꯤꯄꯣꯔꯠ ꯄꯤꯌꯨ',
      'patient_details': 'ꯑꯅꯥꯕꯒꯤ ꯃꯇꯧ ꯀꯔꯝꯕꯥ',
      'symptoms': 'ꯂꯥꯏꯅꯥꯒꯤ ꯃꯦꯠꯇꯥ',
      'severity': 'ꯑꯋꯥꯕꯥ',
      'location': 'ꯃꯐꯝ',
      'diarrhea': 'ꯏꯀꯥꯏ ꯅꯨꯡꯁꯤꯠ',
      'fever': 'ꯂꯥꯏ',
      'vomiting': 'ꯁꯦꯟꯊꯣꯛ',
      'dehydration': 'ꯏꯁꯤꯡ ꯊꯣꯡꯗꯣꯀꯄꯥ',
      'hand_washing': 'ꯈꯨꯠ ꯊꯣꯡꯗꯣꯀꯄꯥ',
      'safe_water': 'ꯑꯁꯣꯛ-ꯑꯁꯅꯕꯥ ꯏꯁꯤꯡ',
      'food_safety': 'ꯆꯥꯅꯕꯥ ꯔꯛꯁꯅꯕꯥ',
      'prevention_tips': 'ꯅꯥꯕꯥ ꯊꯤꯡꯖꯤꯟꯅꯕꯒꯤ ꯄꯥꯝꯕꯩꯁꯤꯡ',
    },
  };
}
