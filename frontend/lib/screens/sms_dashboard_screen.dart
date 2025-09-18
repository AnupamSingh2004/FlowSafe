import 'package:flutter/material.dart';
import '../services/sms_integration_service.dart';
import '../widgets/localized_text.dart';

class SMSDashboardScreen extends StatefulWidget {
  const SMSDashboardScreen({super.key});

  @override
  State<SMSDashboardScreen> createState() => _SMSDashboardScreenState();
}

class _SMSDashboardScreenState extends State<SMSDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SMSIntegrationService _smsService = SMSIntegrationService();
  
  List<SMSReport> _smsReports = [];
  List<SMSTemplate> _smsTemplates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final reports = await _smsService.getSMSReports();
      final templates = await _smsService.getSMSTemplates();
      
      setState(() {
        _smsReports = reports;
        _smsTemplates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading SMS data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LocalizedText('sms_dashboard'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.message), text: 'Reports'),
            Tab(icon: Icon(Icons.send), text: 'Send Alert'),
            Tab(icon: Icon(Icons.description), text: 'Templates'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildReportsTab(),
                _buildSendAlertTab(),
                _buildTemplatesTab(),
              ],
            ),
    );
  }

  Widget _buildReportsTab() {
    final urgentReports = _smsReports.where((r) => r.status == 'urgent').toList();
    final processedReports = _smsReports.where((r) => r.status == 'processed').toList();
    final pendingReports = _smsReports.where((r) => r.status == 'pending').toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Reports',
                    _smsReports.length.toString(),
                    Icons.message,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Urgent',
                    urgentReports.length.toString(),
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Processed',
                    processedReports.length.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Pending',
                    pendingReports.length.toString(),
                    Icons.hourglass_empty,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Urgent Reports Section
            if (urgentReports.isNotEmpty) ...[
              Text(
                'Urgent Reports',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...urgentReports.map((report) => _buildReportCard(report, isUrgent: true)),
              const SizedBox(height: 24),
            ],

            // All Reports Section
            Text(
              'All SMS Reports',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._smsReports.map((report) => _buildReportCard(report)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(SMSReport report, {bool isUrgent = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUrgent ? 8 : 2,
      color: isUrgent ? Colors.red.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getReportTypeIcon(report.reportType),
                  color: _getReportTypeColor(report.reportType),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.reportType.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getReportTypeColor(report.reportType),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(report.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  report.senderName,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  report.location,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  report.phoneNumber,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const Spacer(),
                Text(
                  _formatDateTime(report.receivedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                report.message,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            if (report.processedData.isNotEmpty) ...[
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text('Processed Data'),
                tilePadding: EdgeInsets.zero,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: report.processedData.entries
                          .map((entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '${entry.key}: ${entry.value}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSendAlertTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send SMS Alert',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _AlertForm(smsService: _smsService),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SMS Templates',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Use these templates to format your SMS reports:',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ..._smsTemplates.map((template) => _buildTemplateCard(template)),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(SMSTemplate template) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    template.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    template.language.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              template.description,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                template.template,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getReportTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'health':
        return Icons.health_and_safety;
      case 'water_quality':
        return Icons.water_drop;
      case 'outbreak_alert':
        return Icons.warning;
      default:
        return Icons.message;
    }
  }

  Color _getReportTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'health':
        return Colors.green;
      case 'water_quality':
        return Colors.blue;
      case 'outbreak_alert':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'processed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _AlertForm extends StatefulWidget {
  final SMSIntegrationService smsService;

  const _AlertForm({required this.smsService});

  @override
  State<_AlertForm> createState() => _AlertFormState();
}

class _AlertFormState extends State<_AlertForm> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedAlertType = 'health_warning';
  String _selectedPriority = 'medium';
  List<String> _phoneNumbers = [];
  bool _isSending = false;

  final List<String> _alertTypes = [
    'health_warning',
    'water_contamination',
    'outbreak_alert',
    'emergency',
    'general_info'
  ];

  final List<String> _priorities = ['low', 'medium', 'high', 'urgent'];

  @override
  void dispose() {
    _messageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedAlertType,
            decoration: const InputDecoration(
              labelText: 'Alert Type',
              border: OutlineInputBorder(),
            ),
            items: _alertTypes.map((type) => DropdownMenuItem(
              value: type,
              child: Text(type.replaceAll('_', ' ').toUpperCase()),
            )).toList(),
            onChanged: (value) => setState(() => _selectedAlertType = value!),
            validator: (value) => value == null ? 'Please select alert type' : null,
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedPriority,
            decoration: const InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(),
            ),
            items: _priorities.map((priority) => DropdownMenuItem(
              value: priority,
              child: Text(priority.toUpperCase()),
            )).toList(),
            onChanged: (value) => setState(() => _selectedPriority = value!),
            validator: (value) => value == null ? 'Please select priority' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+919876543210',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.add),
            ),
            keyboardType: TextInputType.phone,
            onFieldSubmitted: _addPhoneNumber,
          ),
          const SizedBox(height: 8),
          
          if (_phoneNumbers.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _phoneNumbers.map((number) => Chip(
                label: Text(number),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removePhoneNumber(number),
              )).toList(),
            ),
            const SizedBox(height: 16),
          ],

          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'Message',
              hintText: 'Enter your alert message...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a message';
              }
              if (value.length > 160) {
                return 'Message must be 160 characters or less';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Characters: ${_messageController.text.length}/160',
            style: TextStyle(
              fontSize: 12,
              color: _messageController.text.length > 160 ? Colors.red : Colors.grey,
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _phoneNumbers.isEmpty || _isSending ? null : _sendAlert,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Send Alert'),
            ),
          ),
        ],
      ),
    );
  }

  void _addPhoneNumber(String number) {
    if (number.trim().isNotEmpty && !_phoneNumbers.contains(number.trim())) {
      setState(() {
        _phoneNumbers.add(number.trim());
        _phoneController.clear();
      });
    }
  }

  void _removePhoneNumber(String number) {
    setState(() {
      _phoneNumbers.remove(number);
    });
  }

  Future<void> _sendAlert() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      final alert = SMSAlert(
        phoneNumbers: _phoneNumbers,
        message: _messageController.text.trim(),
        alertType: _selectedAlertType,
        priority: _selectedPriority,
        scheduledAt: DateTime.now(),
      );

      final response = await widget.smsService.sendSMSAlert(alert);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.success 
                ? 'Alert sent successfully!' 
                : 'Failed to send alert: ${response.message}'),
            backgroundColor: response.success ? Colors.green : Colors.red,
          ),
        );

        if (response.success) {
          _formKey.currentState!.reset();
          _messageController.clear();
          setState(() {
            _phoneNumbers.clear();
            _selectedAlertType = 'health_warning';
            _selectedPriority = 'medium';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending alert: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }
}
