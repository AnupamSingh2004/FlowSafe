import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class OfflineDataService extends ChangeNotifier {
  static final OfflineDataService _instance = OfflineDataService._internal();
  factory OfflineDataService() => _instance;
  OfflineDataService._internal();

  // Keys for different types of offline data
  static const String _waterQualityReports = 'offline_water_quality_reports';
  static const String _diseaseReports = 'offline_disease_reports';
  static const String _communityReports = 'offline_community_reports';

  List<Map<String, dynamic>> _waterQualityQueue = [];
  List<Map<String, dynamic>> _diseaseReportQueue = [];
  List<Map<String, dynamic>> _communityReportQueue = [];
  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;
  bool get hasOfflineData => 
      _waterQualityQueue.isNotEmpty || 
      _diseaseReportQueue.isNotEmpty || 
      _communityReportQueue.isNotEmpty;

  int get totalOfflineReports => 
      _waterQualityQueue.length + 
      _diseaseReportQueue.length + 
      _communityReportQueue.length;

  Future<void> initialize() async {
    await _loadOfflineData();
  }

  Future<void> _loadOfflineData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load water quality reports
      final waterQualityData = prefs.getString(_waterQualityReports);
      if (waterQualityData != null) {
        _waterQualityQueue = List<Map<String, dynamic>>.from(
          json.decode(waterQualityData).map((item) => Map<String, dynamic>.from(item))
        );
      }

      // Load disease reports
      final diseaseData = prefs.getString(_diseaseReports);
      if (diseaseData != null) {
        _diseaseReportQueue = List<Map<String, dynamic>>.from(
          json.decode(diseaseData).map((item) => Map<String, dynamic>.from(item))
        );
      }

      // Load community reports
      final communityData = prefs.getString(_communityReports);
      if (communityData != null) {
        _communityReportQueue = List<Map<String, dynamic>>.from(
          json.decode(communityData).map((item) => Map<String, dynamic>.from(item))
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading offline data: $e');
    }
  }

  Future<void> _saveOfflineData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_waterQualityReports, json.encode(_waterQualityQueue));
      await prefs.setString(_diseaseReports, json.encode(_diseaseReportQueue));
      await prefs.setString(_communityReports, json.encode(_communityReportQueue));
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving offline data: $e');
    }
  }

  // Store water quality report offline
  Future<void> storeWaterQualityReport(Map<String, dynamic> reportData) async {
    reportData['offline_id'] = DateTime.now().toIso8601String();
    reportData['type'] = 'water_quality';
    reportData['status'] = 'pending_sync';
    reportData['created_offline'] = true;
    
    _waterQualityQueue.add(reportData);
    await _saveOfflineData();
  }

  // Store disease report offline
  Future<void> storeDiseaseReport(Map<String, dynamic> reportData) async {
    reportData['offline_id'] = DateTime.now().toIso8601String();
    reportData['type'] = 'disease_surveillance';
    reportData['status'] = 'pending_sync';
    reportData['created_offline'] = true;
    
    _diseaseReportQueue.add(reportData);
    await _saveOfflineData();
  }

  // Store community report offline
  Future<void> storeCommunityReport(Map<String, dynamic> reportData) async {
    reportData['offline_id'] = DateTime.now().toIso8601String();
    reportData['type'] = 'community_report';
    reportData['status'] = 'pending_sync';
    reportData['created_offline'] = true;
    
    _communityReportQueue.add(reportData);
    await _saveOfflineData();
  }

  // Get all offline reports for display
  List<Map<String, dynamic>> getAllOfflineReports() {
    List<Map<String, dynamic>> allReports = [];
    allReports.addAll(_waterQualityQueue);
    allReports.addAll(_diseaseReportQueue);
    allReports.addAll(_communityReportQueue);
    
    // Sort by creation time (newest first)
    allReports.sort((a, b) => 
      b['offline_id'].toString().compareTo(a['offline_id'].toString())
    );
    
    return allReports;
  }

  // Sync all offline data (when internet is available)
  Future<bool> syncAllData() async {
    if (_isSyncing) return false;
    
    _isSyncing = true;
    notifyListeners();
    
    try {
      bool allSuccess = true;
      
      // Sync water quality reports
      for (int i = _waterQualityQueue.length - 1; i >= 0; i--) {
        final report = _waterQualityQueue[i];
        final success = await _syncSingleReport(report);
        if (success) {
          _waterQualityQueue.removeAt(i);
        } else {
          allSuccess = false;
        }
      }
      
      // Sync disease reports
      for (int i = _diseaseReportQueue.length - 1; i >= 0; i--) {
        final report = _diseaseReportQueue[i];
        final success = await _syncSingleReport(report);
        if (success) {
          _diseaseReportQueue.removeAt(i);
        } else {
          allSuccess = false;
        }
      }
      
      // Sync community reports
      for (int i = _communityReportQueue.length - 1; i >= 0; i--) {
        final report = _communityReportQueue[i];
        final success = await _syncSingleReport(report);
        if (success) {
          _communityReportQueue.removeAt(i);
        } else {
          allSuccess = false;
        }
      }
      
      await _saveOfflineData();
      return allSuccess;
      
    } catch (e) {
      debugPrint('Error syncing offline data: $e');
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<bool> _syncSingleReport(Map<String, dynamic> report) async {
    try {
      // Simulate API call - replace with actual API implementation
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Here you would make the actual API call based on report type
      switch (report['type']) {
        case 'water_quality':
          // Call water quality API
          break;
        case 'disease_surveillance':
          // Call disease surveillance API
          break;
        case 'community_report':
          // Call community report API
          break;
      }
      
      // For now, simulate success
      return true;
    } catch (e) {
      debugPrint('Error syncing report ${report['offline_id']}: $e');
      return false;
    }
  }

  // Delete a specific offline report
  Future<void> deleteOfflineReport(String offlineId) async {
    _waterQualityQueue.removeWhere((report) => report['offline_id'] == offlineId);
    _diseaseReportQueue.removeWhere((report) => report['offline_id'] == offlineId);
    _communityReportQueue.removeWhere((report) => report['offline_id'] == offlineId);
    
    await _saveOfflineData();
  }

  // Clear all offline data
  Future<void> clearAllOfflineData() async {
    _waterQualityQueue.clear();
    _diseaseReportQueue.clear();
    _communityReportQueue.clear();
    
    await _saveOfflineData();
  }

  // Get sync status summary
  Map<String, dynamic> getSyncStatus() {
    return {
      'total_reports': totalOfflineReports,
      'water_quality_reports': _waterQualityQueue.length,
      'disease_reports': _diseaseReportQueue.length,
      'community_reports': _communityReportQueue.length,
      'is_syncing': _isSyncing,
      'has_offline_data': hasOfflineData,
    };
  }

  // Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      // Simulate connectivity check - replace with actual implementation
      await Future.delayed(const Duration(milliseconds: 100));
      return true; // For demo purposes
    } catch (e) {
      return false;
    }
  }

  // Auto-sync when internet becomes available
  Future<void> attemptAutoSync() async {
    if (!hasOfflineData || _isSyncing) return;
    
    final hasInternet = await hasInternetConnection();
    if (hasInternet) {
      await syncAllData();
    }
  }
}
