import 'package:flutter/material.dart';

class HygieneEducationScreen extends StatefulWidget {
  final String userType;
  
  const HygieneEducationScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<HygieneEducationScreen> createState() => _HygieneEducationScreenState();
}

class _HygieneEducationScreenState extends State<HygieneEducationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<EducationModule> _modules = [
    EducationModule(
      title: 'Safe Water Practices',
      icon: Icons.water_drop,
      color: Color(0xFF1976D2),
      lessons: [
        Lesson(
          title: 'Water Purification Methods',
          content: '''
**Boiling Water:**
• Boil water for at least 5-10 minutes
• Let it cool before drinking
• Store in clean, covered containers

**Water Purification Tablets:**
• Follow packet instructions carefully
• Wait recommended time before drinking
• One tablet typically treats 1 liter

**Solar Disinfection (SODIS):**
• Fill clear plastic bottles with water
• Expose to direct sunlight for 6 hours
• Effective against bacteria and viruses

**Simple Filtration:**
• Use clean cloth to filter visible particles
• Sand and charcoal filters for better results
• Always combine with other purification methods
          ''',
          tips: [
            'Never drink water from unknown sources',
            'Check water clarity before treatment',
            'Store treated water properly',
          ],
        ),
        Lesson(
          title: 'Safe Water Storage',
          content: '''
**Clean Storage Containers:**
• Use containers with narrow mouths
• Clean with soap and disinfect regularly
• Keep covered at all times

**Proper Handling:**
• Use clean ladle or cup to remove water
• Never put hands inside storage container
• Keep containers elevated from ground

**Regular Cleaning:**
• Wash containers weekly with soap
• Rinse thoroughly before refilling
• Dry completely in sunlight if possible

**Signs of Contamination:**
• Bad smell or taste
• Cloudy appearance
• Slimy feeling on container walls
          ''',
          tips: [
            'Label containers with treatment date',
            'Use separate containers for different purposes',
            'Replace old containers regularly',
          ],
        ),
      ],
    ),
    EducationModule(
      title: 'Personal Hygiene',
      icon: Icons.wash,
      color: Color(0xFF42A5F5),
      lessons: [
        Lesson(
          title: 'Proper Handwashing',
          content: '''
**When to Wash Hands:**
• Before eating or cooking
• After using toilet
• After handling animals
• Before caring for babies
• After coughing or sneezing

**How to Wash Properly:**
1. Wet hands with clean water
2. Apply soap (bar or liquid)
3. Rub palms together
4. Rub between fingers
5. Clean under nails
6. Scrub for 20 seconds minimum
7. Rinse with clean water
8. Dry with clean towel or air dry

**When Soap Unavailable:**
• Use ash mixed with water
• Rub hands with sand/soil (clean)
• Use alcohol-based sanitizer (60%+ alcohol)
          ''',
          tips: [
            'Sing a song while washing (20 seconds)',
            'Keep nails short and clean',
            'Use separate towels for hands',
          ],
        ),
        Lesson(
          title: 'Food Safety & Hygiene',
          content: '''
**Safe Food Preparation:**
• Wash hands before cooking
• Use clean utensils and surfaces
• Keep raw and cooked foods separate
• Cook food thoroughly (especially meat)

**Food Storage:**
• Store food in covered containers
• Keep perishables cool/refrigerated
• Use cooked food within 2 hours
• Reheat food properly before eating

**Safe Eating Practices:**
• Eat food while hot
• Avoid street food from questionable sources
• Wash fruits and vegetables
• Use safe water for cooking

**Signs of Food Spoilage:**
• Bad smell or appearance
• Slimy texture
• Mold growth
• Unusual taste
          ''',
          tips: [
            'When in doubt, throw it out',
            'Keep cooking area clean',
            'Wash utensils after each use',
          ],
        ),
      ],
    ),
    EducationModule(
      title: 'Disease Prevention',
      icon: Icons.shield,
      color: Color(0xFF64B5F6),
      lessons: [
        Lesson(
          title: 'Water-borne Disease Prevention',
          content: '''
**Common Water-borne Diseases:**
• Diarrhea and Dysentery
• Cholera
• Typhoid Fever
• Hepatitis A
• Gastroenteritis

**Prevention Strategies:**
• Drink only safe, treated water
• Maintain proper sanitation
• Practice good personal hygiene
• Avoid contaminated food/water
• Get recommended vaccinations

**Early Warning Signs:**
• Frequent loose stools
• Vomiting and nausea
• Fever and weakness
• Abdominal pain
• Dehydration symptoms

**Immediate Actions:**
• Increase fluid intake (ORS)
• Maintain hygiene
• Seek medical help if severe
• Isolate if highly contagious
          ''',
          tips: [
            'Report unusual illness patterns to health workers',
            'Keep ORS packets at home',
            'Know location of nearest health facility',
          ],
        ),
        Lesson(
          title: 'Community Health Practices',
          content: '''
**Environmental Sanitation:**
• Proper waste disposal
• Clean surroundings
• Maintain drainage systems
• Keep water sources protected

**Community Involvement:**
• Share health information
• Support sick community members
• Participate in cleaning drives
• Report health concerns to authorities

**Seasonal Precautions:**
• Extra care during monsoons
• Protect water sources from flooding
• Increase surveillance during outbreaks
• Follow government health advisories

**Traditional Practices:**
• Validate with modern health knowledge
• Seek medical advice when needed
• Combine traditional and modern approaches
• Avoid harmful practices
          ''',
          tips: [
            'Organize community health meetings',
            'Create awareness among neighbors',
            'Support pregnant women and children',
          ],
        ),
      ],
    ),
    EducationModule(
      title: 'Emergency Response',
      icon: Icons.emergency,
      color: Color(0xFF90CAF9),
      lessons: [
        Lesson(
          title: 'Recognizing Health Emergencies',
          content: '''
**Severe Dehydration Signs:**
• Excessive thirst
• Dry mouth and tongue
• Little or no urination
• Dizziness or weakness
• Sunken eyes (in children)

**When to Seek Immediate Help:**
• Blood in vomit or stool
• High fever (>102°F/39°C)
• Signs of severe dehydration
• Difficulty breathing
• Loss of consciousness

**First Aid for Diarrhea:**
• Give ORS solution frequently
• Continue breastfeeding (infants)
• Offer light, easily digestible food
• Monitor for worsening symptoms
• Keep patient comfortable

**Emergency Contacts:**
• Local health worker number
• Nearest hospital/clinic
• Emergency ambulance service
• District health office
          ''',
          tips: [
            'Keep emergency numbers handy',
            'Learn to prepare ORS at home',
            'Know fastest route to health facility',
          ],
        ),
        Lesson(
          title: 'Outbreak Response',
          content: '''
**Reporting Procedures:**
• Notify ASHA/health worker immediately
• Provide accurate information
• Cooperate with health investigations
• Follow isolation guidelines if needed

**Community Actions:**
• Increase hygiene practices
• Avoid mass gatherings if advised
• Support affected families
• Follow official health advisories

**Water Source Protection:**
• Avoid using suspected contaminated sources
• Implement alternative water arrangements
• Report contamination to authorities
• Support community water testing

**Information Sharing:**
• Use reliable sources only
• Avoid spreading rumors
• Share factual health information
• Support official communication channels
          ''',
          tips: [
            'Stay calm and follow instructions',
            'Help elderly and vulnerable people',
            'Maintain accurate records of symptoms',
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Hygiene & Disease Prevention',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _modules.length,
              itemBuilder: (context, index) {
                return _buildModulePage(_modules[index]);
              },
            ),
          ),
          _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: List.generate(_modules.length, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentPage 
                    ? const Color(0xFF1976D2) 
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildModulePage(EducationModule module) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModuleHeader(module),
          const SizedBox(height: 24),
          ...module.lessons.map((lesson) => _buildLessonCard(lesson)).toList(),
        ],
      ),
    );
  }

  Widget _buildModuleHeader(EducationModule module) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [module.color, module.color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                module.icon,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${module.lessons.length} lessons',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
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

  Widget _buildLessonCard(Lesson lesson) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(Icons.school, color: Color(0xFF1976D2)),
        title: Text(
          lesson.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                if (lesson.tips.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Quick Tips:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...lesson.tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb, 
                             size: 16, 
                             color: Colors.amber[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tip,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentPage > 0
              ? ElevatedButton.icon(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
          Row(
            children: List.generate(_modules.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPage 
                      ? const Color(0xFF1976D2) 
                      : Colors.grey[300],
                ),
              );
            }),
          ),
          _currentPage < _modules.length - 1
              ? ElevatedButton.icon(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class EducationModule {
  final String title;
  final IconData icon;
  final Color color;
  final List<Lesson> lessons;

  EducationModule({
    required this.title,
    required this.icon,
    required this.color,
    required this.lessons,
  });
}

class Lesson {
  final String title;
  final String content;
  final List<String> tips;

  Lesson({
    required this.title,
    required this.content,
    required this.tips,
  });
}
