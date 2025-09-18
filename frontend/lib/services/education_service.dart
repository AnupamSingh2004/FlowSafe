import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/google_auth_config.dart';

class EducationService {
  static String get _baseUrl => GoogleAuthConfig.apiBaseUrl;

  Future<List<EducationModule>> getEducationModules() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/education/modules/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => EducationModule.fromJson(json)).toList();
      } else {
        // Return mock data if API is not available
        return _getMockEducationModules();
      }
    } catch (e) {
      print('Error fetching education modules: $e');
      return _getMockEducationModules();
    }
  }

  Future<List<QuizQuestion>> getQuizQuestions(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/education/quiz/$category/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => QuizQuestion.fromJson(json)).toList();
      } else {
        return _getMockQuizQuestions(category);
      }
    } catch (e) {
      print('Error fetching quiz questions: $e');
      return _getMockQuizQuestions(category);
    }
  }

  Future<QuizResult> submitQuizResult(QuizResult result) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/education/quiz-results/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(result.toJson()),
      );

      if (response.statusCode == 201) {
        return QuizResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to submit quiz result');
      }
    } catch (e) {
      print('Error submitting quiz result: $e');
      return result.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
  }

  List<EducationModule> _getMockEducationModules() {
    return [
      EducationModule(
        id: '1',
        title: 'Safe Water Practices',
        description: 'Learn essential water safety techniques',
        category: 'water_safety',
        duration: 5,
        language: 'English',
        videoUrl: 'https://example.com/water-safety.mp4',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        content: _getWaterSafetyContent(),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      EducationModule(
        id: '2',
        title: 'पानी की सुरक्षा',
        description: 'पानी की सुरक्षा की आवश्यक तकनीकें सीखें',
        category: 'water_safety',
        duration: 5,
        language: 'Hindi',
        videoUrl: 'https://example.com/water-safety-hi.mp4',
        thumbnailUrl: 'https://example.com/thumb1.jpg',
        content: _getWaterSafetyContent(),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      EducationModule(
        id: '3',
        title: 'Proper Handwashing',
        description: 'Step-by-step handwashing guide',
        category: 'hygiene',
        duration: 3,
        language: 'English',
        videoUrl: 'https://example.com/handwashing.mp4',
        thumbnailUrl: 'https://example.com/thumb2.jpg',
        content: _getHandwashingContent(),
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      EducationModule(
        id: '4',
        title: 'Disease Prevention',
        description: 'Preventing waterborne diseases',
        category: 'disease_prevention',
        duration: 8,
        language: 'English',
        videoUrl: 'https://example.com/disease-prevention.mp4',
        thumbnailUrl: 'https://example.com/thumb3.jpg',
        content: _getDiseasePreventionContent(),
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      EducationModule(
        id: '5',
        title: 'Community Hygiene',
        description: 'Maintaining community cleanliness',
        category: 'hygiene',
        duration: 6,
        language: 'English',
        videoUrl: 'https://example.com/community-hygiene.mp4',
        thumbnailUrl: 'https://example.com/thumb4.jpg',
        content: _getCommunityHygieneContent(),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  List<QuizQuestion> _getMockQuizQuestions(String category) {
    switch (category) {
      case 'water_safety':
        return [
          QuizQuestion(
            id: '1',
            question: 'How long should you boil water to make it safe for drinking?',
            options: ['30 seconds', '1 minute', '5 minutes', '10 minutes'],
            correctAnswer: 1,
            explanation: 'Boiling water for at least 1 minute kills most harmful bacteria and viruses.',
          ),
          QuizQuestion(
            id: '2',
            question: 'Which of these is NOT a safe water storage practice?',
            options: ['Cover the container', 'Clean container weekly', 'Store in sunlight', 'Keep away from contamination'],
            correctAnswer: 2,
            explanation: 'Storing water in direct sunlight can promote bacterial growth.',
          ),
        ];
      case 'hygiene':
        return [
          QuizQuestion(
            id: '3',
            question: 'How long should you wash your hands with soap?',
            options: ['5 seconds', '10 seconds', '20 seconds', '1 minute'],
            correctAnswer: 2,
            explanation: 'Washing hands for 20 seconds is recommended to effectively remove germs.',
          ),
          QuizQuestion(
            id: '4',
            question: 'When should you wash your hands?',
            options: ['Before eating', 'After using toilet', 'After touching surfaces', 'All of the above'],
            correctAnswer: 3,
            explanation: 'Hand washing is important before eating, after using toilet, and after touching potentially contaminated surfaces.',
          ),
        ];
      case 'disease_prevention':
        return [
          QuizQuestion(
            id: '5',
            question: 'Which disease is commonly caused by contaminated water?',
            options: ['Malaria', 'Cholera', 'Tuberculosis', 'Diabetes'],
            correctAnswer: 1,
            explanation: 'Cholera is a waterborne disease caused by contaminated water and food.',
          ),
          QuizQuestion(
            id: '6',
            question: 'What is the best way to prevent waterborne diseases?',
            options: ['Take medicine', 'Drink clean water and maintain hygiene', 'Stay indoors', 'Avoid vegetables'],
            correctAnswer: 1,
            explanation: 'Drinking clean water and maintaining good hygiene are the most effective prevention methods.',
          ),
        ];
      default:
        return [];
    }
  }

  String _getWaterSafetyContent() {
    return '''
# Water Safety Guidelines

## Key Points:
- Always boil water for at least 1 minute before drinking
- Store boiled water in clean, covered containers
- Use water purification tablets if boiling is not possible
- Keep water sources protected from contamination
- Test water quality regularly

## Signs of Contaminated Water:
- Unusual color or cloudiness
- Strange smell or taste
- Visible particles or debris
- Growth of algae or bacteria

## Emergency Water Treatment:
1. Boiling (most effective)
2. Water purification tablets
3. UV sterilization
4. Filtration through clean cloth
''';
  }

  String _getHandwashingContent() {
    return '''
# Proper Handwashing Technique

## 5 Simple Steps:
1. **Wet** your hands with clean water
2. **Apply** soap and lather well
3. **Scrub** for at least 20 seconds
4. **Rinse** thoroughly with clean water
5. **Dry** with a clean cloth or air dry

## When to Wash Hands:
- Before eating or preparing food
- After using the toilet
- After touching animals or waste
- After coughing or sneezing
- After touching surfaces in public places

## Remember:
- Use soap whenever possible
- Hand sanitizer (60%+ alcohol) is an alternative when soap isn't available
- Clean fingernails regularly
''';
  }

  String _getDiseasePreventionContent() {
    return '''
# Waterborne Disease Prevention

## Common Waterborne Diseases:
- **Diarrhea**: Loose stools, dehydration
- **Cholera**: Severe diarrhea, vomiting
- **Typhoid**: High fever, stomach pain
- **Hepatitis A**: Jaundice, fatigue

## Prevention Strategies:
1. **Safe Water**: Boil, purify, or use bottled water
2. **Food Safety**: Cook thoroughly, eat hot food
3. **Personal Hygiene**: Wash hands frequently
4. **Sanitation**: Use proper toilets and waste disposal

## Warning Signs:
- Persistent diarrhea
- High fever
- Severe dehydration
- Blood in stool
- Persistent vomiting

*Seek medical attention immediately if symptoms persist*
''';
  }

  String _getCommunityHygieneContent() {
    return '''
# Community Hygiene Practices

## Community Responsibilities:
- Keep water sources clean and protected
- Proper waste management and disposal
- Maintain clean public toilets
- Educate community members about hygiene

## Collective Actions:
- Regular cleaning of community areas
- Proper sewage management
- Vector control (mosquitoes, flies)
- Emergency preparedness

## Individual Contributions:
- Don't litter or pollute water sources
- Report contamination issues
- Participate in community clean-up drives
- Share knowledge with others
''';
  }
}

class EducationModule {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration; // in minutes
  final String language;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String content;
  final DateTime createdAt;

  EducationModule({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.language,
    this.videoUrl,
    this.thumbnailUrl,
    required this.content,
    required this.createdAt,
  });

  factory EducationModule.fromJson(Map<String, dynamic> json) {
    return EducationModule(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      duration: json['duration'] ?? 0,
      language: json['language'] ?? 'English',
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'duration': duration,
      'language': language,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id']?.toString() ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? 0,
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
    };
  }
}

class QuizResult {
  final String? id;
  final String category;
  final int score;
  final int totalQuestions;
  final List<int> userAnswers;
  final DateTime completedAt;

  QuizResult({
    this.id,
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.userAnswers,
    required this.completedAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id']?.toString(),
      category: json['category'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      userAnswers: List<int>.from(json['user_answers'] ?? []),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'category': category,
      'score': score,
      'total_questions': totalQuestions,
      'user_answers': userAnswers,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  QuizResult copyWith({
    String? id,
    String? category,
    int? score,
    int? totalQuestions,
    List<int>? userAnswers,
    DateTime? completedAt,
  }) {
    return QuizResult(
      id: id ?? this.id,
      category: category ?? this.category,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      userAnswers: userAnswers ?? this.userAnswers,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  double get percentage => totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;
  bool get isPassed => percentage >= 80;
}
