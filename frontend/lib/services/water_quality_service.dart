import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/google_auth_config.dart';

class WaterQualityService {
  static String get _baseUrl => GoogleAuthConfig.apiBaseUrl;

  Future<List<WaterSource>> getWaterSources() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/water-quality/sources/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WaterSource.fromJson(json)).toList();
      } else {
        // Return mock data if API is not available
        return _getMockWaterSources();
      }
    } catch (e) {
      print('Error fetching water sources: $e');
      // Return mock data on error
      return _getMockWaterSources();
    }
  }

  Future<WaterQualityReading> submitWaterQualityReading(WaterQualityReading reading) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/water-quality/readings/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reading.toJson()),
      );

      if (response.statusCode == 201) {
        return WaterQualityReading.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to submit water quality reading');
      }
    } catch (e) {
      print('Error submitting water quality reading: $e');
      rethrow;
    }
  }

  Future<List<WaterQualityAlert>> getWaterQualityAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/water-quality/alerts/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WaterQualityAlert.fromJson(json)).toList();
      } else {
        return _getMockAlerts();
      }
    } catch (e) {
      print('Error fetching water quality alerts: $e');
      return _getMockAlerts();
    }
  }

  List<WaterSource> _getMockWaterSources() {
    return [
      WaterSource(
        id: '1',
        name: 'Village Well - Majuli',
        location: 'Majuli Island, Assam',
        latitude: 26.9354,
        longitude: 94.2182,
        phLevel: 7.2,
        turbidity: 2.1,
        bacterialCount: 0,
        dissolvedOxygen: 8.5,
        temperature: 25.3,
        conductivity: 450,
        safetyLevel: 'safe',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        type: 'well',
      ),
      WaterSource(
        id: '2',
        name: 'River Source - Brahmaputra',
        location: 'Guwahati, Assam',
        latitude: 26.1445,
        longitude: 91.7362,
        phLevel: 6.8,
        turbidity: 4.5,
        bacterialCount: 15,
        dissolvedOxygen: 7.2,
        temperature: 23.8,
        conductivity: 520,
        safetyLevel: 'warning',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
        type: 'river',
      ),
      WaterSource(
        id: '3',
        name: 'Tube Well - Dibrugarh',
        location: 'Dibrugarh District, Assam',
        latitude: 27.4728,
        longitude: 94.9120,
        phLevel: 5.8,
        turbidity: 8.2,
        bacterialCount: 45,
        dissolvedOxygen: 5.1,
        temperature: 28.2,
        conductivity: 680,
        safetyLevel: 'danger',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        type: 'tubewell',
      ),
      WaterSource(
        id: '4',
        name: 'Community Pond - Jorhat',
        location: 'Jorhat, Assam',
        latitude: 26.7509,
        longitude: 94.2037,
        phLevel: 7.5,
        turbidity: 1.8,
        bacterialCount: 2,
        dissolvedOxygen: 9.1,
        temperature: 24.7,
        conductivity: 420,
        safetyLevel: 'safe',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
        type: 'pond',
      ),
      WaterSource(
        id: '5',
        name: 'Mountain Stream - Tezpur',
        location: 'Tezpur, Assam',
        latitude: 26.6337,
        longitude: 92.7933,
        phLevel: 6.5,
        turbidity: 3.2,
        bacterialCount: 8,
        dissolvedOxygen: 8.8,
        temperature: 22.1,
        conductivity: 380,
        safetyLevel: 'warning',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 45)),
        type: 'stream',
      ),
    ];
  }

  List<WaterQualityAlert> _getMockAlerts() {
    return [
      WaterQualityAlert(
        id: '1',
        sourceId: '3',
        sourceName: 'Tube Well - Dibrugarh',
        alertType: 'contamination',
        severity: 'high',
        message: 'High bacterial count detected. Immediate treatment required.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isActive: true,
      ),
      WaterQualityAlert(
        id: '2',
        sourceId: '2',
        sourceName: 'River Source - Brahmaputra',
        alertType: 'turbidity',
        severity: 'medium',
        message: 'Elevated turbidity levels. Monitor closely.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isActive: true,
      ),
    ];
  }
}

class WaterSource {
  final String id;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final double phLevel;
  final double turbidity;
  final int bacterialCount;
  final double dissolvedOxygen;
  final double temperature;
  final double conductivity;
  final String safetyLevel;
  final DateTime lastUpdated;
  final String type;

  WaterSource({
    required this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.phLevel,
    required this.turbidity,
    required this.bacterialCount,
    required this.dissolvedOxygen,
    required this.temperature,
    required this.conductivity,
    required this.safetyLevel,
    required this.lastUpdated,
    required this.type,
  });

  factory WaterSource.fromJson(Map<String, dynamic> json) {
    return WaterSource(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phLevel: (json['ph_level'] ?? 7.0).toDouble(),
      turbidity: (json['turbidity'] ?? 0.0).toDouble(),
      bacterialCount: json['bacterial_count'] ?? 0,
      dissolvedOxygen: (json['dissolved_oxygen'] ?? 0.0).toDouble(),
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      conductivity: (json['conductivity'] ?? 0.0).toDouble(),
      safetyLevel: json['safety_level'] ?? 'unknown',
      lastUpdated: json['last_updated'] != null 
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
      type: json['type'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'ph_level': phLevel,
      'turbidity': turbidity,
      'bacterial_count': bacterialCount,
      'dissolved_oxygen': dissolvedOxygen,
      'temperature': temperature,
      'conductivity': conductivity,
      'safety_level': safetyLevel,
      'last_updated': lastUpdated.toIso8601String(),
      'type': type,
    };
  }

  String getMainIssue() {
    if (bacterialCount > 10) return 'High bacterial contamination';
    if (phLevel < 6.5 || phLevel > 8.5) return 'pH level out of range';
    if (turbidity > 5.0) return 'High turbidity';
    if (dissolvedOxygen < 6.0) return 'Low dissolved oxygen';
    return 'Multiple parameters need attention';
  }
}

class WaterQualityReading {
  final String? id;
  final String sourceId;
  final double phLevel;
  final double turbidity;
  final int bacterialCount;
  final double dissolvedOxygen;
  final double temperature;
  final double conductivity;
  final String testedBy;
  final DateTime timestamp;
  final String? notes;

  WaterQualityReading({
    this.id,
    required this.sourceId,
    required this.phLevel,
    required this.turbidity,
    required this.bacterialCount,
    required this.dissolvedOxygen,
    required this.temperature,
    required this.conductivity,
    required this.testedBy,
    required this.timestamp,
    this.notes,
  });

  factory WaterQualityReading.fromJson(Map<String, dynamic> json) {
    return WaterQualityReading(
      id: json['id']?.toString(),
      sourceId: json['source_id']?.toString() ?? '',
      phLevel: (json['ph_level'] ?? 7.0).toDouble(),
      turbidity: (json['turbidity'] ?? 0.0).toDouble(),
      bacterialCount: json['bacterial_count'] ?? 0,
      dissolvedOxygen: (json['dissolved_oxygen'] ?? 0.0).toDouble(),
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      conductivity: (json['conductivity'] ?? 0.0).toDouble(),
      testedBy: json['tested_by'] ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'source_id': sourceId,
      'ph_level': phLevel,
      'turbidity': turbidity,
      'bacterial_count': bacterialCount,
      'dissolved_oxygen': dissolvedOxygen,
      'temperature': temperature,
      'conductivity': conductivity,
      'tested_by': testedBy,
      'timestamp': timestamp.toIso8601String(),
      if (notes != null) 'notes': notes,
    };
  }
}

class WaterQualityAlert {
  final String id;
  final String sourceId;
  final String sourceName;
  final String alertType;
  final String severity;
  final String message;
  final DateTime timestamp;
  final bool isActive;

  WaterQualityAlert({
    required this.id,
    required this.sourceId,
    required this.sourceName,
    required this.alertType,
    required this.severity,
    required this.message,
    required this.timestamp,
    required this.isActive,
  });

  factory WaterQualityAlert.fromJson(Map<String, dynamic> json) {
    return WaterQualityAlert(
      id: json['id']?.toString() ?? '',
      sourceId: json['source_id']?.toString() ?? '',
      sourceName: json['source_name'] ?? '',
      alertType: json['alert_type'] ?? '',
      severity: json['severity'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_id': sourceId,
      'source_name': sourceName,
      'alert_type': alertType,
      'severity': severity,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_active': isActive,
    };
  }
}
