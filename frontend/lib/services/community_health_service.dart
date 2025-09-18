import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/google_auth_config.dart';

class CommunityHealthService {
  static String get _baseUrl => GoogleAuthConfig.apiBaseUrl;

  Future<List<HealthReport>> getMyReports() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health-reports/my-reports/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => HealthReport.fromJson(json)).toList();
      } else {
        // Return mock data if API is not available
        return _getMockReports();
      }
    } catch (e) {
      print('Error fetching reports: $e');
      return _getMockReports();
    }
  }

  Future<HealthReport> submitReport(HealthReport report) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/health-reports/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(report.toJson()),
      );

      if (response.statusCode == 201) {
        return HealthReport.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to submit health report');
      }
    } catch (e) {
      print('Error submitting report: $e');
      // For demo purposes, return the report with an ID
      return report.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        status: 'pending',
      );
    }
  }

  Future<HealthStatistics> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health-reports/statistics/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return HealthStatistics.fromJson(json.decode(response.body));
      } else {
        return _getMockStatistics();
      }
    } catch (e) {
      print('Error fetching statistics: $e');
      return _getMockStatistics();
    }
  }

  Future<List<HealthAlert>> getHealthAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health-alerts/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => HealthAlert.fromJson(json)).toList();
      } else {
        return _getMockHealthAlerts();
      }
    } catch (e) {
      print('Error fetching health alerts: $e');
      return _getMockHealthAlerts();
    }
  }

  List<HealthReport> _getMockReports() {
    return [
      HealthReport(
        id: '1',
        patientName: 'Ravi Kumar',
        age: 35,
        gender: 'Male',
        contactNumber: '+91 9876543210',
        address: 'Village Majuli, Assam',
        symptoms: ['Fever', 'Diarrhea', 'Vomiting'],
        severityLevel: 'Moderate',
        latitude: 26.9354,
        longitude: 94.2182,
        notes: 'Patient has been sick for 3 days',
        submittedBy: 'asha_worker',
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        status: 'approved',
        attachmentUrls: [],
      ),
      HealthReport(
        id: '2',
        patientName: 'Priya Das',
        age: 28,
        gender: 'Female',
        contactNumber: '+91 9123456789',
        address: 'Guwahati, Assam',
        symptoms: ['Stomach pain', 'Nausea', 'Weakness'],
        severityLevel: 'Mild',
        latitude: 26.1445,
        longitude: 91.7362,
        notes: 'Mild symptoms, patient improving',
        submittedBy: 'community_volunteer',
        submittedAt: DateTime.now().subtract(const Duration(hours: 6)),
        status: 'pending',
        attachmentUrls: [],
      ),
    ];
  }

  HealthStatistics _getMockStatistics() {
    return HealthStatistics(
      totalReports: 15,
      thisMonth: 8,
      approved: 12,
      pending: 3,
      rejected: 0,
    );
  }

  List<HealthAlert> _getMockHealthAlerts() {
    return [
      HealthAlert(
        id: '1',
        title: 'Diarrhea Outbreak Alert',
        message: 'Increased cases of diarrhea reported in Majuli area. Take precautionary measures.',
        severity: 'high',
        affectedArea: 'Majuli, Assam',
        alertType: 'outbreak',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      HealthAlert(
        id: '2',
        title: 'Water Contamination Warning',
        message: 'Water quality issues detected in Dibrugarh district. Use alternative water sources.',
        severity: 'medium',
        affectedArea: 'Dibrugarh, Assam',
        alertType: 'water_quality',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }
}

class HealthReport {
  final String id;
  final String patientName;
  final int age;
  final String gender;
  final String contactNumber;
  final String address;
  final List<String> symptoms;
  final String severityLevel;
  final double? latitude;
  final double? longitude;
  final String notes;
  final String submittedBy;
  final DateTime submittedAt;
  final String status;
  final List<String> attachmentUrls;

  HealthReport({
    required this.id,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.contactNumber,
    required this.address,
    required this.symptoms,
    required this.severityLevel,
    this.latitude,
    this.longitude,
    required this.notes,
    required this.submittedBy,
    required this.submittedAt,
    required this.status,
    required this.attachmentUrls,
  });

  factory HealthReport.fromJson(Map<String, dynamic> json) {
    return HealthReport(
      id: json['id']?.toString() ?? '',
      patientName: json['patient_name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      address: json['address'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      severityLevel: json['severity_level'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      notes: json['notes'] ?? '',
      submittedBy: json['submitted_by'] ?? '',
      submittedAt: json['submitted_at'] != null 
          ? DateTime.parse(json['submitted_at'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      attachmentUrls: List<String>.from(json['attachment_urls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'age': age,
      'gender': gender,
      'contact_number': contactNumber,
      'address': address,
      'symptoms': symptoms,
      'severity_level': severityLevel,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'submitted_by': submittedBy,
      'submitted_at': submittedAt.toIso8601String(),
      'status': status,
      'attachment_urls': attachmentUrls,
    };
  }

  HealthReport copyWith({
    String? id,
    String? patientName,
    int? age,
    String? gender,
    String? contactNumber,
    String? address,
    List<String>? symptoms,
    String? severityLevel,
    double? latitude,
    double? longitude,
    String? notes,
    String? submittedBy,
    DateTime? submittedAt,
    String? status,
    List<String>? attachmentUrls,
  }) {
    return HealthReport(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      symptoms: symptoms ?? this.symptoms,
      severityLevel: severityLevel ?? this.severityLevel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      submittedBy: submittedBy ?? this.submittedBy,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
    );
  }
}

class HealthStatistics {
  final int totalReports;
  final int thisMonth;
  final int approved;
  final int pending;
  final int rejected;

  HealthStatistics({
    required this.totalReports,
    required this.thisMonth,
    required this.approved,
    required this.pending,
    required this.rejected,
  });

  factory HealthStatistics.fromJson(Map<String, dynamic> json) {
    return HealthStatistics(
      totalReports: json['total_reports'] ?? 0,
      thisMonth: json['this_month'] ?? 0,
      approved: json['approved'] ?? 0,
      pending: json['pending'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }

  factory HealthStatistics.empty() {
    return HealthStatistics(
      totalReports: 0,
      thisMonth: 0,
      approved: 0,
      pending: 0,
      rejected: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_reports': totalReports,
      'this_month': thisMonth,
      'approved': approved,
      'pending': pending,
      'rejected': rejected,
    };
  }
}

class HealthAlert {
  final String id;
  final String title;
  final String message;
  final String severity;
  final String affectedArea;
  final String alertType;
  final bool isActive;
  final DateTime createdAt;

  HealthAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.affectedArea,
    required this.alertType,
    required this.isActive,
    required this.createdAt,
  });

  factory HealthAlert.fromJson(Map<String, dynamic> json) {
    return HealthAlert(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      severity: json['severity'] ?? '',
      affectedArea: json['affected_area'] ?? '',
      alertType: json['alert_type'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'severity': severity,
      'affected_area': affectedArea,
      'alert_type': alertType,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
