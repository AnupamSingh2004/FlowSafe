import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HealthDataService {
  static const String _baseUrl = 'https://your-api-endpoint.com/api';
  static const String _localStoragePrefix = 'health_data_';

  // Generic method to save data locally and sync with server
  static Future<void> _saveDataWithSync(String dataType, Map<String, dynamic> data) async {
    try {
      // Add metadata
      data['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      data['synced'] = false;
      data['localTimestamp'] = DateTime.now().toIso8601String();

      // Save locally first
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getStringList('${_localStoragePrefix}$dataType') ?? [];
      existingData.add(jsonEncode(data));
      await prefs.setStringList('${_localStoragePrefix}$dataType', existingData);

      // Try to sync with server
      await _syncWithServer(dataType, data);
    } catch (e) {
      print('Error saving $dataType data: $e');
      rethrow;
    }
  }

  // Sync data with server
  static Future<void> _syncWithServer(String dataType, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/health-data/$dataType'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mark as synced locally
        data['synced'] = true;
        data['serverResponse'] = jsonDecode(response.body);
        await _updateLocalData(dataType, data);
      } else {
        throw Exception('Server sync failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Sync failed for $dataType: $e');
      // Data remains in local storage for later sync
    }
  }

  // Update local data after successful sync
  static Future<void> _updateLocalData(String dataType, Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = prefs.getStringList('${_localStoragePrefix}$dataType') ?? [];
    
    for (int i = 0; i < existingData.length; i++) {
      final item = jsonDecode(existingData[i]);
      if (item['id'] == updatedData['id']) {
        existingData[i] = jsonEncode(updatedData);
        break;
      }
    }
    
    await prefs.setStringList('${_localStoragePrefix}$dataType', existingData);
  }

  // Get authentication token
  static Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // Save clinic data
  static Future<void> saveClinicData(Map<String, dynamic> data) async {
    await _saveDataWithSync('clinic', data);
  }

  // Save ASHA worker data
  static Future<void> saveASHAData(Map<String, dynamic> data) async {
    await _saveDataWithSync('asha', data);
  }

  // Save volunteer data
  static Future<void> saveVolunteerData(Map<String, dynamic> data) async {
    await _saveDataWithSync('volunteer', data);
  }

  // Save field survey data
  static Future<void> saveSurveyData(Map<String, dynamic> data) async {
    await _saveDataWithSync('survey', data);
  }

  // Save health camp data
  static Future<void> saveHealthCampData(Map<String, dynamic> data) async {
    await _saveDataWithSync('health_camp', data);
  }

  // Save emergency report data
  static Future<void> saveEmergencyReport(Map<String, dynamic> data) async {
    data['priority'] = 'HIGH';
    data['alertAuthorities'] = true;
    await _saveDataWithSync('emergency', data);
    
    // Send immediate alert to authorities
    await _sendEmergencyAlert(data);
  }

  // Send emergency alert
  static Future<void> _sendEmergencyAlert(Map<String, dynamic> data) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/emergency-alert'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode({
          'type': 'emergency_health_report',
          'data': data,
          'timestamp': DateTime.now().toIso8601String(),
          'alert_level': 'CRITICAL',
        }),
      );
    } catch (e) {
      print('Emergency alert failed: $e');
    }
  }

  // Get all data of a specific type
  static Future<List<Map<String, dynamic>>> getData(String dataType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataList = prefs.getStringList('${_localStoragePrefix}$dataType') ?? [];
      
      return dataList.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting $dataType data: $e');
      return [];
    }
  }

  // Get statistics for dashboard
  static Future<Map<String, dynamic>> getDataStatistics() async {
    try {
      final clinicData = await getData('clinic');
      final ashaData = await getData('asha');
      final volunteerData = await getData('volunteer');
      final surveyData = await getData('survey');
      final campData = await getData('health_camp');
      final emergencyData = await getData('emergency');

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      return {
        'totalRecords': clinicData.length + ashaData.length + volunteerData.length + 
                       surveyData.length + campData.length,
        'todayRecords': _getTodayRecords([
          ...clinicData, ...ashaData, ...volunteerData, 
          ...surveyData, ...campData
        ], todayStart),
        'pendingSync': _getPendingSyncCount([
          ...clinicData, ...ashaData, ...volunteerData, 
          ...surveyData, ...campData, ...emergencyData
        ]),
        'emergencyReports': emergencyData.length,
        'byType': {
          'clinic': clinicData.length,
          'asha': ashaData.length,
          'volunteer': volunteerData.length,
          'survey': surveyData.length,
          'healthCamp': campData.length,
          'emergency': emergencyData.length,
        },
        'syncStatus': {
          'synced': _getSyncedCount([
            ...clinicData, ...ashaData, ...volunteerData, 
            ...surveyData, ...campData, ...emergencyData
          ]),
          'pending': _getPendingSyncCount([
            ...clinicData, ...ashaData, ...volunteerData, 
            ...surveyData, ...campData, ...emergencyData
          ]),
        }
      };
    } catch (e) {
      print('Error getting statistics: $e');
      return {};
    }
  }

  // Helper method to count today's records
  static int _getTodayRecords(List<Map<String, dynamic>> data, DateTime todayStart) {
    return data.where((item) {
      try {
        final timestamp = DateTime.parse(item['timestamp'] ?? item['localTimestamp']);
        return timestamp.isAfter(todayStart);
      } catch (e) {
        return false;
      }
    }).length;
  }

  // Helper method to count pending sync records
  static int _getPendingSyncCount(List<Map<String, dynamic>> data) {
    return data.where((item) => item['synced'] == false).length;
  }

  // Helper method to count synced records
  static int _getSyncedCount(List<Map<String, dynamic>> data) {
    return data.where((item) => item['synced'] == true).length;
  }

  // Sync all pending data
  static Future<void> syncAllPendingData() async {
    try {
      final dataTypes = ['clinic', 'asha', 'volunteer', 'survey', 'health_camp', 'emergency'];
      
      for (String dataType in dataTypes) {
        final data = await getData(dataType);
        final pendingData = data.where((item) => item['synced'] == false).toList();
        
        for (var item in pendingData) {
          await _syncWithServer(dataType, item);
        }
      }
    } catch (e) {
      print('Error syncing all data: $e');
    }
  }

  // Export data for backup
  static Future<Map<String, dynamic>> exportAllData() async {
    try {
      return {
        'exportDate': DateTime.now().toIso8601String(),
        'data': {
          'clinic': await getData('clinic'),
          'asha': await getData('asha'),
          'volunteer': await getData('volunteer'),
          'survey': await getData('survey'),
          'healthCamp': await getData('health_camp'),
          'emergency': await getData('emergency'),
        },
        'statistics': await getDataStatistics(),
      };
    } catch (e) {
      print('Error exporting data: $e');
      return {};
    }
  }

  // Clear old data (older than specified days)
  static Future<void> clearOldData({int daysToKeep = 90}) async {
    try {
      final dataTypes = ['clinic', 'asha', 'volunteer', 'survey', 'health_camp', 'emergency'];
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      
      for (String dataType in dataTypes) {
        final data = await getData(dataType);
        final filteredData = data.where((item) {
          try {
            final timestamp = DateTime.parse(item['timestamp'] ?? item['localTimestamp']);
            return timestamp.isAfter(cutoffDate);
          } catch (e) {
            return true; // Keep data if timestamp is invalid
          }
        }).toList();
        
        final prefs = await SharedPreferences.getInstance();
        final encodedData = filteredData.map((item) => jsonEncode(item)).toList();
        await prefs.setStringList('${_localStoragePrefix}$dataType', encodedData);
      }
    } catch (e) {
      print('Error clearing old data: $e');
    }
  }

  // Search data across all types
  static Future<List<Map<String, dynamic>>> searchData(String query) async {
    try {
      final allData = <Map<String, dynamic>>[];
      final dataTypes = ['clinic', 'asha', 'volunteer', 'survey', 'health_camp', 'emergency'];
      
      for (String dataType in dataTypes) {
        final data = await getData(dataType);
        for (var item in data) {
          item['dataType'] = dataType;
          allData.add(item);
        }
      }
      
      // Filter by query
      return allData.where((item) {
        final searchString = item.values.join(' ').toLowerCase();
        return searchString.contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching data: $e');
      return [];
    }
  }

  // Get network connectivity status
  static Future<bool> isOnline() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health-check'),
        headers: {'Authorization': 'Bearer ${await _getAuthToken()}'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Validate data before saving
  static bool validateData(String dataType, Map<String, dynamic> data) {
    switch (dataType) {
      case 'clinic':
        return data['patientId'] != null && 
               data['patientName'] != null && 
               data['symptoms'] != null;
      case 'asha':
        return data['familyId'] != null && 
               data['headOfFamily'] != null && 
               data['observations'] != null;
      case 'volunteer':
        return data['activityTitle'] != null && 
               data['activityType'] != null && 
               data['description'] != null;
      case 'survey':
        return data['householdId'] != null && 
               data['householdHead'] != null && 
               data['observations'] != null;
      case 'health_camp':
        return data['campId'] != null && 
               data['campName'] != null && 
               data['location'] != null;
      case 'emergency':
        return data['reportType'] != null && 
               data['description'] != null && 
               data['location'] != null;
      default:
        return false;
    }
  }
}
