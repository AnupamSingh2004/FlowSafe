import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/google_auth_config.dart';

class OfflineSyncService {
  static const String _pendingReportsKey = 'pending_reports';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _offlineDataKey = 'offline_data';
  
  static String get _baseUrl => GoogleAuthConfig.apiBaseUrl;

  // Check if device is currently online by attempting a simple HTTP request
  Future<bool> isOnline() async {
    try {
      final result = await http.get(
        Uri.parse('https://www.google.com'),
        headers: {'Connection': 'close'},
      ).timeout(const Duration(seconds: 5));
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Save data for offline use
  Future<void> saveOfflineData(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final offlineData = prefs.getString(_offlineDataKey) ?? '{}';
      final Map<String, dynamic> allOfflineData = json.decode(offlineData);
      
      allOfflineData[key] = data;
      
      await prefs.setString(_offlineDataKey, json.encode(allOfflineData));
    } catch (e) {
      print('Error saving offline data: $e');
    }
  }

  // Get offline data by key
  Future<Map<String, dynamic>?> getOfflineData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final offlineData = prefs.getString(_offlineDataKey) ?? '{}';
      final Map<String, dynamic> allOfflineData = json.decode(offlineData);
      
      return allOfflineData[key];
    } catch (e) {
      print('Error getting offline data: $e');
      return null;
    }
  }

  // Save pending report for later sync
  Future<void> savePendingReport(PendingReport report) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingReportsJson = prefs.getString(_pendingReportsKey) ?? '[]';
      final List<dynamic> pendingReports = json.decode(pendingReportsJson);
      
      pendingReports.add(report.toJson());
      
      await prefs.setString(_pendingReportsKey, json.encode(pendingReports));
      print('Saved pending report: ${report.type}');
    } catch (e) {
      print('Error saving pending report: $e');
    }
  }

  // Get all pending reports
  Future<List<PendingReport>> getPendingReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingReportsJson = prefs.getString(_pendingReportsKey) ?? '[]';
      final List<dynamic> pendingReports = json.decode(pendingReportsJson);
      
      return pendingReports
          .map((json) => PendingReport.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting pending reports: $e');
      return [];
    }
  }

  // Sync all pending reports when online
  Future<SyncResult> syncPendingReports() async {
    final syncResult = SyncResult();
    
    if (!await isOnline()) {
      syncResult.success = false;
      syncResult.message = 'Device is offline';
      return syncResult;
    }

    try {
      final pendingReports = await getPendingReports();
      
      if (pendingReports.isEmpty) {
        syncResult.success = true;
        syncResult.message = 'No pending reports to sync';
        return syncResult;
      }

      final List<PendingReport> syncedReports = [];
      
      for (final report in pendingReports) {
        try {
          final success = await _syncSingleReport(report);
          if (success) {
            syncedReports.add(report);
            syncResult.syncedCount++;
          } else {
            syncResult.failedCount++;
          }
        } catch (e) {
          print('Error syncing report ${report.id}: $e');
          syncResult.failedCount++;
        }
      }

      // Remove successfully synced reports
      await _removeSyncedReports(syncedReports);

      // Update last sync timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);

      syncResult.success = syncResult.failedCount == 0;
      syncResult.message = syncResult.success
          ? 'All reports synced successfully'
          : '${syncResult.syncedCount} synced, ${syncResult.failedCount} failed';

    } catch (e) {
      syncResult.success = false;
      syncResult.message = 'Sync failed: $e';
    }

    return syncResult;
  }

  // Sync a single report
  Future<bool> _syncSingleReport(PendingReport report) async {
    try {
      String endpoint;
      switch (report.type) {
        case 'health_report':
          endpoint = '/community-health/reports/';
          break;
        case 'water_quality':
          endpoint = '/water-quality/reports/';
          break;
        case 'sms_report':
          endpoint = '/sms/process-report/';
          break;
        default:
          endpoint = '/general/reports/';
      }

      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (report.authToken != null) 'Authorization': 'Bearer ${report.authToken}',
        },
        body: json.encode(report.data),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error syncing single report: $e');
      return false;
    }
  }

  // Remove synced reports from pending list
  Future<void> _removeSyncedReports(List<PendingReport> syncedReports) async {
    try {
      final allPendingReports = await getPendingReports();
      final syncedIds = syncedReports.map((r) => r.id).toSet();
      
      final remainingReports = allPendingReports
          .where((report) => !syncedIds.contains(report.id))
          .toList();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _pendingReportsKey,
        json.encode(remainingReports.map((r) => r.toJson()).toList()),
      );
    } catch (e) {
      print('Error removing synced reports: $e');
    }
  }

  // Get last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastSyncKey);
      return timestamp != null 
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      print('Error getting last sync time: $e');
      return null;
    }
  }

  // Save image files for offline use
  Future<String?> saveOfflineImage(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final offlineDir = Directory('${directory.path}/offline_images');
      
      if (!await offlineDir.exists()) {
        await offlineDir.create(recursive: true);
      }

      final sourceFile = File(imagePath);
      if (!await sourceFile.exists()) {
        return null;
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imagePath.split('/').last}';
      final targetPath = '${offlineDir.path}/$fileName';
      
      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (e) {
      print('Error saving offline image: $e');
      return null;
    }
  }

  // Get offline storage info
  Future<OfflineStorageInfo> getStorageInfo() async {
    try {
      final pendingReports = await getPendingReports();
      final lastSync = await getLastSyncTime();
      
      // Calculate storage usage
      final directory = await getApplicationDocumentsDirectory();
      final offlineDir = Directory('${directory.path}/offline_images');
      
      int imageCount = 0;
      int totalSize = 0;
      
      if (await offlineDir.exists()) {
        final files = await offlineDir.list().toList();
        imageCount = files.length;
        
        for (final file in files) {
          if (file is File) {
            final stat = await file.stat();
            totalSize += stat.size;
          }
        }
      }

      return OfflineStorageInfo(
        pendingReportsCount: pendingReports.length,
        offlineImagesCount: imageCount,
        totalStorageSize: totalSize,
        lastSyncTime: lastSync,
      );
    } catch (e) {
      print('Error getting storage info: $e');
      return OfflineStorageInfo(
        pendingReportsCount: 0,
        offlineImagesCount: 0,
        totalStorageSize: 0,
        lastSyncTime: null,
      );
    }
  }

  // Clear all offline data
  Future<void> clearOfflineData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingReportsKey);
      await prefs.remove(_offlineDataKey);
      
      // Clear offline images
      final directory = await getApplicationDocumentsDirectory();
      final offlineDir = Directory('${directory.path}/offline_images');
      
      if (await offlineDir.exists()) {
        await offlineDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing offline data: $e');
    }
  }

  // Auto-sync by checking periodically
  void startAutoSync() {
    // Check for connectivity every 30 seconds and sync if online
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (await isOnline()) {
        final pendingReports = await getPendingReports();
        if (pendingReports.isNotEmpty) {
          print('Auto-sync triggered - attempting to sync ${pendingReports.length} reports');
          final syncResult = await syncPendingReports();
          print('Auto-sync result: ${syncResult.message}');
        }
      }
    });
  }
}

class PendingReport {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final String? authToken;
  final List<String> attachedFiles;

  PendingReport({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.authToken,
    this.attachedFiles = const [],
  });

  factory PendingReport.fromJson(Map<String, dynamic> json) {
    return PendingReport(
      id: json['id'],
      type: json['type'],
      data: Map<String, dynamic>.from(json['data']),
      createdAt: DateTime.parse(json['created_at']),
      authToken: json['auth_token'],
      attachedFiles: List<String>.from(json['attached_files'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'auth_token': authToken,
      'attached_files': attachedFiles,
    };
  }
}

class SyncResult {
  bool success = false;
  String message = '';
  int syncedCount = 0;
  int failedCount = 0;

  SyncResult({
    this.success = false,
    this.message = '',
    this.syncedCount = 0,
    this.failedCount = 0,
  });
}

class OfflineStorageInfo {
  final int pendingReportsCount;
  final int offlineImagesCount;
  final int totalStorageSize;
  final DateTime? lastSyncTime;

  OfflineStorageInfo({
    required this.pendingReportsCount,
    required this.offlineImagesCount,
    required this.totalStorageSize,
    this.lastSyncTime,
  });

  String get formattedStorageSize {
    if (totalStorageSize < 1024) {
      return '${totalStorageSize}B';
    } else if (totalStorageSize < 1024 * 1024) {
      return '${(totalStorageSize / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(totalStorageSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  String get lastSyncFormatted {
    if (lastSyncTime == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
