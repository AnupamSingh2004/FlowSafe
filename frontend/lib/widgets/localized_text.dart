import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class LocalizedText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? fallback;

  const LocalizedText(
    this.textKey, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        String translatedText = languageService.translate(textKey);
        if (translatedText == textKey && fallback != null) {
          translatedText = fallback!;
        }
        
        return Text(
          translatedText,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

class LocalizedTextSpan extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final String? fallback;

  const LocalizedTextSpan(
    this.textKey, {
    Key? key,
    this.style,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        String translatedText = languageService.translate(textKey);
        if (translatedText == textKey && fallback != null) {
          translatedText = fallback!;
        }
        
        return Text.rich(
          TextSpan(
            text: translatedText,
            style: style,
          ),
        );
      },
    );
  }
}

// Helper function for getting localized strings directly
String getLocalizedText(BuildContext context, String textKey, {String? fallback}) {
  final languageService = Provider.of<LanguageService>(context, listen: false);
  String translatedText = languageService.translate(textKey);
  if (translatedText == textKey && fallback != null) {
    return fallback;
  }
  return translatedText;
}
