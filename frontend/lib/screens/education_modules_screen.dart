import 'package:flutter/material.dart';
import '../widgets/localized_text.dart';
import '../services/education_service.dart';

class EducationModulesScreen extends StatefulWidget {
  const EducationModulesScreen({Key? key}) : super(key: key);

  @override
  State<EducationModulesScreen> createState() => _EducationModulesScreenState();
}

class _EducationModulesScreenState extends State<EducationModulesScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EducationService _educationService = EducationService();
  List<EducationModule> educationModules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadEducationModules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEducationModules() async {
    setState(() => isLoading = true);
    try {
      final modules = await _educationService.getEducationModules();
      setState(() {
        educationModules = modules;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showError('Failed to load education modules: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const LocalizedText('hygiene_education'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.water_drop), text: 'Water Safety'),
            Tab(icon: Icon(Icons.wash), text: 'Hygiene'),
            Tab(icon: Icon(Icons.medical_services), text: 'Disease Prevention'),
            Tab(icon: Icon(Icons.quiz), text: 'Quick Quiz'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildWaterSafetyTab(),
                _buildHygieneTab(),
                _buildDiseasePreventionTab(),
                _buildQuizTab(),
              ],
            ),
    );
  }

  Widget _buildWaterSafetyTab() {
    final waterSafetyModules = educationModules
        .where((m) => m.category == 'water_safety')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(
            'Safe Water Practices',
            'Learn how to ensure clean water for your family and community',
            Icons.water_drop,
            const Color(0xFF0277BD),
          ),
          const SizedBox(height: 20),
          _buildTipsSection(
            'Water Safety Tips',
            [
              'Boil water for at least 1 minute before drinking',
              'Store boiled water in clean containers',
              'Use water purification tablets if boiling is not possible',
              'Keep water sources covered and away from contamination',
              'Test water quality regularly using test kits',
              'Clean water storage containers weekly',
            ],
            Icons.lightbulb,
            Colors.orange,
          ),
          const SizedBox(height: 20),
          _buildVideoSection('Water Safety Videos', waterSafetyModules),
          const SizedBox(height: 20),
          _buildInteractiveSection('Water Quality Testing', 'Learn how to test water quality at home'),
        ],
      ),
    );
  }

  Widget _buildHygieneTab() {
    final hygieneModules = educationModules
        .where((m) => m.category == 'hygiene')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(
            'Personal Hygiene',
            'Essential hygiene practices to prevent waterborne diseases',
            Icons.wash,
            const Color(0xFF00796B),
          ),
          const SizedBox(height: 20),
          _buildHandwashingGuide(),
          const SizedBox(height: 20),
          _buildTipsSection(
            'Daily Hygiene Practices',
            [
              'Wash hands with soap for 20 seconds regularly',
              'Clean hands before eating and after using toilet',
              'Use hand sanitizer when soap is not available',
              'Keep fingernails clean and trimmed',
              'Wash fruits and vegetables before eating',
              'Maintain clean cooking and eating areas',
            ],
            Icons.health_and_safety,
            Colors.green,
          ),
          const SizedBox(height: 20),
          _buildVideoSection('Hygiene Demonstrations', hygieneModules),
        ],
      ),
    );
  }

  Widget _buildDiseasePreventionTab() {
    final diseaseModules = educationModules
        .where((m) => m.category == 'disease_prevention')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(
            'Disease Prevention',
            'Understand and prevent common waterborne diseases',
            Icons.shield,
            const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 20),
          _buildDiseaseInfoCards(),
          const SizedBox(height: 20),
          _buildPreventionStrategies(),
          const SizedBox(height: 20),
          _buildVideoSection('Disease Prevention Videos', diseaseModules),
          const SizedBox(height: 20),
          _buildEmergencyContacts(),
        ],
      ),
    );
  }

  Widget _buildQuizTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(
            'Quick Quiz',
            'Test your knowledge about water safety and hygiene',
            Icons.quiz,
            const Color(0xFF7B1FA2),
          ),
          const SizedBox(height: 20),
          _buildQuizCategories(),
          const SizedBox(height: 20),
          _buildCertificateSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection(String title, List<String> tips, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection(String title, List<EducationModule> modules) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (modules.isEmpty)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Educational videos coming soon',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return _buildVideoCard(module);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(EducationModule module) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.play_arrow, color: Color(0xFF1976D2)),
        ),
        title: Text(module.title),
        subtitle: Text('${module.duration} min • ${module.language}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _playVideo(module),
      ),
    );
  }

  Widget _buildHandwashingGuide() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.wash, color: Color(0xFF00796B)),
                SizedBox(width: 8),
                Text(
                  'Proper Handwashing Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHandwashingStep(1, 'Wet your hands with clean water'),
            _buildHandwashingStep(2, 'Apply soap and lather well'),
            _buildHandwashingStep(3, 'Scrub for at least 20 seconds'),
            _buildHandwashingStep(4, 'Rinse thoroughly with clean water'),
            _buildHandwashingStep(5, 'Dry with a clean cloth or air dry'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00796B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.timer, color: Color(0xFF00796B)),
                  SizedBox(width: 8),
                  Text(
                    'Remember: Wash hands for 20 seconds (sing "Happy Birthday" twice!)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandwashingStep(int step, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF00796B),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseInfoCards() {
    final diseases = [
      {
        'name': 'Diarrhea',
        'symptoms': 'Loose stools, dehydration, fever',
        'prevention': 'Clean water, good hygiene',
        'color': Colors.orange,
      },
      {
        'name': 'Cholera',
        'symptoms': 'Severe diarrhea, vomiting, dehydration',
        'prevention': 'Safe water, proper sanitation',
        'color': Colors.red,
      },
      {
        'name': 'Typhoid',
        'symptoms': 'High fever, headache, stomach pain',
        'prevention': 'Vaccination, clean water, hygiene',
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Common Waterborne Diseases',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...diseases.map((disease) => _buildDiseaseCard(disease)).toList(),
      ],
    );
  }

  Widget _buildDiseaseCard(Map<String, dynamic> disease) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: disease['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.coronavirus,
                    color: disease['color'],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  disease['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDiseaseInfo('Symptoms', disease['symptoms']),
            _buildDiseaseInfo('Prevention', disease['prevention']),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo(String label, String info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(info)),
        ],
      ),
    );
  }

  Widget _buildPreventionStrategies() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shield, color: Color(0xFFD32F2F)),
                SizedBox(width: 8),
                Text(
                  'Prevention Strategies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPreventionStrategy(
              'Water Safety',
              'Always drink boiled or purified water',
              Icons.water_drop,
              Colors.blue,
            ),
            _buildPreventionStrategy(
              'Food Hygiene',
              'Cook food thoroughly and eat while hot',
              Icons.restaurant,
              Colors.orange,
            ),
            _buildPreventionStrategy(
              'Personal Hygiene',
              'Wash hands frequently with soap',
              Icons.wash,
              Colors.green,
            ),
            _buildPreventionStrategy(
              'Sanitation',
              'Use proper toilet facilities and waste disposal',
              Icons.wc,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreventionStrategy(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emergency, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Emergency Contacts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildEmergencyContact('Medical Emergency', '108', Icons.local_hospital),
            _buildEmergencyContact('District Health Officer', '+91-XXXX-XXXX', Icons.phone),
            _buildEmergencyContact('Water Quality Department', '+91-XXXX-XXXX', Icons.water),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact(String service, String number, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // Launch phone dialer
          _makePhoneCall(number);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      number,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.call, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCategories() {
    final quizCategories = [
      {
        'title': 'Water Safety Quiz',
        'description': '10 questions about safe water practices',
        'questions': 10,
        'duration': 5,
        'color': Colors.blue,
        'icon': Icons.water_drop,
      },
      {
        'title': 'Hygiene Quiz',
        'description': '8 questions about personal hygiene',
        'questions': 8,
        'duration': 4,
        'color': Colors.green,
        'icon': Icons.wash,
      },
      {
        'title': 'Disease Prevention Quiz',
        'description': '12 questions about preventing waterborne diseases',
        'questions': 12,
        'duration': 6,
        'color': Colors.red,
        'icon': Icons.shield,
      },
    ];

    return Column(
      children: quizCategories.map((quiz) => _buildQuizCard(quiz)).toList(),
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _startQuiz(quiz),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: quiz['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(quiz['icon'], color: quiz['color']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quiz['description'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildQuizStat('${quiz['questions']} questions', Icons.quiz),
                        const SizedBox(width: 16),
                        _buildQuizStat('${quiz['duration']} min', Icons.timer),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: quiz['color']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStat(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCertificateSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.card_membership, size: 48, color: Color(0xFF7B1FA2)),
            const SizedBox(height: 12),
            const Text(
              'Earn Your Certificate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete all quizzes with 80% or higher score to earn your Health Education Certificate',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Show certificate progress
                _showCertificateProgress();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B1FA2),
                foregroundColor: Colors.white,
              ),
              child: const Text('View Progress'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveSection(String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.touch_app, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Launch interactive module
                _launchInteractiveModule(title);
              },
              child: const Text('Start Interactive Learning'),
            ),
          ],
        ),
      ),
    );
  }

  void _playVideo(EducationModule module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(module.title),
        content: Text('Video player integration coming soon.\n\nThis would play: ${module.title}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _startQuiz(Map<String, dynamic> quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(quiz['title']),
        content: Text('Quiz feature coming soon.\n\nThis would start: ${quiz['title']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCertificateProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Certificate Progress'),
        content: const Text('Certificate tracking feature coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _launchInteractiveModule(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('Interactive module feature coming soon.\n\nThis would launch: $title'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String number) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Would call: $number'),
        backgroundColor: const Color(0xFF1976D2),
      ),
    );
  }
}
