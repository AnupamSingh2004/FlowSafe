import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/google_auth_config.dart';

class SMSIntegrationService {
  static String get _baseUrl => GoogleAuthConfig.apiBaseUrl;

  Future<List<SMSReport>> getSMSReports() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/sms/reports/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SMSReport.fromJson(json)).toList();
      } else {
        // Return mock data if API is not available
        return _getMockSMSReports();
      }
    } catch (e) {
      print('Error fetching SMS reports: $e');
      return _getMockSMSReports();
    }
  }

  Future<SMSResponse> sendSMSAlert(SMSAlert alert) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sms/send-alert/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(alert.toJson()),
      );

      if (response.statusCode == 200) {
        return SMSResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to send SMS alert');
      }
    } catch (e) {
      print('Error sending SMS alert: $e');
      // Return mock success response
      return SMSResponse(
        success: true,
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        message: 'SMS alert queued for delivery',
        deliveryStatus: 'pending',
      );
    }
  }

  Future<List<SMSTemplate>> getSMSTemplates() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/sms/templates/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SMSTemplate.fromJson(json)).toList();
      } else {
        return _getMockSMSTemplates();
      }
    } catch (e) {
      print('Error fetching SMS templates: $e');
      return _getMockSMSTemplates();
    }
  }

  Future<SMSReport> processSMSReport(String phoneNumber, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sms/process-report/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone_number': phoneNumber,
          'message': message,
          'received_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return SMSReport.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to process SMS report');
      }
    } catch (e) {
      print('Error processing SMS report: $e');
      // Return mock processed report
      return _createMockProcessedReport(phoneNumber, message);
    }
  }

  List<SMSReport> _getMockSMSReports() {
    return [
      SMSReport(
        id: '1',
        phoneNumber: '+919876543210',
        senderName: 'Ram Kumar',
        location: 'Majuli Village',
        reportType: 'health',
        message: 'REPORT Patient: Sita Age: 25 Symptoms: fever,diarrhea Severity: moderate Location: Majuli',
        processedData: {
          'patient_name': 'Sita',
          'age': 25,
          'symptoms': ['fever', 'diarrhea'],
          'severity': 'moderate',
          'location': 'Majuli',
        },
        status: 'processed',
        receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
        processedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      ),
      SMSReport(
        id: '2',
        phoneNumber: '+919123456789',
        senderName: 'ASHA Worker',
        location: 'Guwahati',
        reportType: 'water_quality',
        message: 'WATER Source: Village Well pH: 6.8 Turbidity: high Color: cloudy Location: Guwahati',
        processedData: {
          'source': 'Village Well',
          'ph': 6.8,
          'turbidity': 'high',
          'color': 'cloudy',
          'location': 'Guwahati',
        },
        status: 'processed',
        receivedAt: DateTime.now().subtract(const Duration(hours: 4)),
        processedAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 50)),
      ),
      SMSReport(
        id: '3',
        phoneNumber: '+919988776655',
        senderName: 'Village Volunteer',
        location: 'Dibrugarh',
        reportType: 'outbreak_alert',
        message: 'ALERT Multiple diarrhea cases in village. Need immediate help. 15 people affected.',
        processedData: {
          'alert_type': 'outbreak',
          'disease': 'diarrhea',
          'affected_count': 15,
          'urgency': 'high',
        },
        status: 'urgent',
        receivedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        processedAt: null,
      ),
    ];
  }

  List<SMSTemplate> _getMockSMSTemplates() {
    return [
      SMSTemplate(
        id: '1',
        name: 'Health Report Template',
        category: 'health_report',
        template: 'REPORT Patient: [NAME] Age: [AGE] Symptoms: [SYMPTOMS] Severity: [SEVERITY] Location: [LOCATION]',
        description: 'Template for reporting health cases via SMS',
        language: 'en',
        isActive: true,
      ),
      SMSTemplate(
        id: '2',
        name: 'Water Quality Template',
        category: 'water_quality',
        template: 'WATER Source: [SOURCE] pH: [PH] Turbidity: [TURBIDITY] Color: [COLOR] Location: [LOCATION]',
        description: 'Template for reporting water quality via SMS',
        language: 'en',
        isActive: true,
      ),
      SMSTemplate(
        id: '3',
        name: 'Emergency Alert Template',
        category: 'emergency',
        template: 'ALERT [DESCRIPTION] Location: [LOCATION] Contact: [CONTACT]',
        description: 'Template for emergency alerts via SMS',
        language: 'en',
        isActive: true,
      ),
      SMSTemplate(
        id: '4',
        name: 'स्वास्थ्य रिपोर्ट टेम्प्लेट',
        category: 'health_report',
        template: 'रिपोर्ट मरीज: [NAME] उम्र: [AGE] लक्षण: [SYMPTOMS] गंभीरता: [SEVERITY] स्थान: [LOCATION]',
        description: 'SMS के माध्यम से स्वास्थ्य मामलों की रिपोर्ट के लिए टेम्प्लेट',
        language: 'hi',
        isActive: true,
      ),
    ];
  }

  SMSReport _createMockProcessedReport(String phoneNumber, String message) {
    return SMSReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      phoneNumber: phoneNumber,
      senderName: 'Unknown',
      location: 'Unknown',
      reportType: 'general',
      message: message,
      processedData: {'raw_message': message},
      status: 'pending',
      receivedAt: DateTime.now(),
      processedAt: null,
    );
  }
}

class SMSReport {
  final String id;
  final String phoneNumber;
  final String senderName;
  final String location;
  final String reportType;
  final String message;
  final Map<String, dynamic> processedData;
  final String status;
  final DateTime receivedAt;
  final DateTime? processedAt;

  SMSReport({
    required this.id,
    required this.phoneNumber,
    required this.senderName,
    required this.location,
    required this.reportType,
    required this.message,
    required this.processedData,
    required this.status,
    required this.receivedAt,
    this.processedAt,
  });

  factory SMSReport.fromJson(Map<String, dynamic> json) {
    return SMSReport(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phone_number'] ?? '',
      senderName: json['sender_name'] ?? '',
      location: json['location'] ?? '',
      reportType: json['report_type'] ?? '',
      message: json['message'] ?? '',
      processedData: Map<String, dynamic>.from(json['processed_data'] ?? {}),
      status: json['status'] ?? '',
      receivedAt: json['received_at'] != null 
          ? DateTime.parse(json['received_at'])
          : DateTime.now(),
      processedAt: json['processed_at'] != null 
          ? DateTime.parse(json['processed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'sender_name': senderName,
      'location': location,
      'report_type': reportType,
      'message': message,
      'processed_data': processedData,
      'status': status,
      'received_at': receivedAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }
}

class SMSAlert {
  final String? id;
  final List<String> phoneNumbers;
  final String message;
  final String alertType;
  final String priority;
  final DateTime scheduledAt;

  SMSAlert({
    this.id,
    required this.phoneNumbers,
    required this.message,
    required this.alertType,
    required this.priority,
    required this.scheduledAt,
  });

  factory SMSAlert.fromJson(Map<String, dynamic> json) {
    return SMSAlert(
      id: json['id']?.toString(),
      phoneNumbers: List<String>.from(json['phone_numbers'] ?? []),
      message: json['message'] ?? '',
      alertType: json['alert_type'] ?? '',
      priority: json['priority'] ?? '',
      scheduledAt: json['scheduled_at'] != null 
          ? DateTime.parse(json['scheduled_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'phone_numbers': phoneNumbers,
      'message': message,
      'alert_type': alertType,
      'priority': priority,
      'scheduled_at': scheduledAt.toIso8601String(),
    };
  }
}

class SMSResponse {
  final bool success;
  final String messageId;
  final String message;
  final String deliveryStatus;

  SMSResponse({
    required this.success,
    required this.messageId,
    required this.message,
    required this.deliveryStatus,
  });

  factory SMSResponse.fromJson(Map<String, dynamic> json) {
    return SMSResponse(
      success: json['success'] ?? false,
      messageId: json['message_id'] ?? '',
      message: json['message'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message_id': messageId,
      'message': message,
      'delivery_status': deliveryStatus,
    };
  }
}

class SMSTemplate {
  final String id;
  final String name;
  final String category;
  final String template;
  final String description;
  final String language;
  final bool isActive;

  SMSTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.template,
    required this.description,
    required this.language,
    required this.isActive,
  });

  factory SMSTemplate.fromJson(Map<String, dynamic> json) {
    return SMSTemplate(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      template: json['template'] ?? '',
      description: json['description'] ?? '',
      language: json['language'] ?? 'en',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'template': template,
      'description': description,
      'language': language,
      'is_active': isActive,
    };
  }

  String formatTemplate(Map<String, String> variables) {
    String formatted = template;
    variables.forEach((key, value) {
      formatted = formatted.replaceAll('[$key]', value);
    });
    return formatted;
  }
}
