import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class LanguageUtils {
  // Current app language
  static String currentLanguage = 'en';  // Default to English
  
  // List of supported languages
  static const List<Map<String, dynamic>> supportedLanguages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
    },
    {
      'code': 'mr',
      'name': 'Marathi',
      'nativeName': 'मराठी',
    },
  ];
  
  // Set the app language
  static void setLanguage(String languageCode) {
    currentLanguage = languageCode;
  }
  
  // Get a localized string
  static String getString(String key) {
    return AppStrings.get(key, language: currentLanguage);
  }
  
  // Format a string with parameters
  static String formatString(String key, Map<String, String> params) {
    return AppStrings.formatSharedText(
      AppStrings.get(key, language: currentLanguage),
      params,
      language: currentLanguage,
    );
  }
  
  // Get current locale
  static Locale getCurrentLocale() {
    return Locale(currentLanguage);
  }
  
  // Check if the current language is RTL
  static bool isRTL() {
    // Add RTL language codes as needed
    const List<String> rtlLanguages = ['ar', 'fa', 'he', 'ur'];
    return rtlLanguages.contains(currentLanguage);
  }
  
  // Get native language name
  static String getNativeLanguageName(String languageCode) {
    for (final language in supportedLanguages) {
      if (language['code'] == languageCode) {
        return language['nativeName'];
      }
    }
    return languageCode;
  }
  
  // Get English language name
  static String getEnglishLanguageName(String languageCode) {
    for (final language in supportedLanguages) {
      if (language['code'] == languageCode) {
        return language['name'];
      }
    }
    return languageCode;
  }
  
  // Convert a number to Marathi if needed
  static String localizeNumber(int number) {
    if (currentLanguage != 'mr') return number.toString();
    
    // Marathi numerals (if needed)
    const Map<String, String> marathiNumerals = {
      '0': '०',
      '1': '१',
      '2': '२',
      '3': '३',
      '4': '४',
      '5': '५',
      '6': '६',
      '7': '७',
      '8': '८',
      '9': '९',
    };
    
    final String numberStr = number.toString();
    String marathiNumber = '';
    
    for (int i = 0; i < numberStr.length; i++) {
      marathiNumber += marathiNumerals[numberStr[i]] ?? numberStr[i];
    }
    
    return marathiNumber;
  }
  
  // Toggle between English and Marathi
  static String toggleLanguage() {
    currentLanguage = currentLanguage == 'en' ? 'mr' : 'en';
    return currentLanguage;
  }
  
  // Build a language selector widget
  static Widget buildLanguageSelector(
    BuildContext context, {
    required void Function(String) onLanguageChanged,
  }) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String languageCode) {
        setLanguage(languageCode);
        onLanguageChanged(languageCode);
      },
      itemBuilder: (BuildContext context) {
        return supportedLanguages.map((language) {
          final bool isSelected = language['code'] == currentLanguage;
          
          return PopupMenuItem<String>(
            value: language['code'],
            child: Row(
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 18,
                  ),
                if (isSelected) const SizedBox(width: 8),
                Text(
                  language['nativeName'],
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${language['name']})',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}