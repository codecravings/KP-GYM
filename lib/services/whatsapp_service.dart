import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/member.dart';
import '../constants/app_strings.dart';

class WhatsAppService {
  // Launch WhatsApp with a message
  static Future<bool> sendMessage(String phoneNumber, String message) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Add country code if not present (assuming India +91)
    String fullNumber = cleanNumber;
    if (!cleanNumber.startsWith('91') && cleanNumber.length == 10) {
      fullNumber = '91$cleanNumber';
    }
    
    final url = Uri.parse('https://wa.me/$fullNumber?text=${Uri.encodeComponent(message)}');
    
    try {
      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
      return false;
    }
  }

  // Share message via WhatsApp
  static Future<bool> shareViaWhatsApp(
    String message, {
    String? phoneNumber,
    BuildContext? context,
  }) async {
    try {
      // If phone number is provided, try direct WhatsApp
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        return await sendMessage(phoneNumber, message);
      }
      
      // Fallback to share dialog
      await Share.share(message);
      return true;
    } catch (e) {
      debugPrint('Error sharing to WhatsApp: $e');
      return false;
    }
  }
  
  // Share subscription reminder for a member
  static Future<bool> shareSubscriptionReminder(
    Member member, {
    BuildContext? context,
    String language = 'en',
  }) async {
    final String message = AppStrings.formatSharedText(
      AppStrings.get('shareMsg', language: language),
      {'days': member.remainingDays.toString()},
      language: language,
    );
    
    return await shareViaWhatsApp(message, context: context);
  }
  
  // Get renewal reminder message in Marathi
  static String getRenewalReminderMarathi(Member member) {
    final daysLeft = member.remainingDays;
    final expiryDate = member.expiryDate;
    
    if (daysLeft == 0) {
      return '''
🏋️‍♂️ *KP GYM* 🏋️‍♂️

नमस्कार ${member.name},

आपले जिम मेंबरशिप आज संपत आहे (${_formatDate(expiryDate)}).

कृपया आपले मेंबरशिप रिन्यू करा आणि आपली फिटनेस जर्नी सुरू ठेवा.

💪 *रिन्यू करण्यासाठी आज भेट द्या!*

धन्यवाद,
KP GYM टीम
''';
    } else if (daysLeft == 1) {
      return '''
🏋️‍♂️ *KP GYM* 🏋️‍♂️

नमस्कार ${member.name},

आपले जिम मेंबरशिप उद्या संपत आहे (${_formatDate(expiryDate)}).

कृपया आपले मेंबरशिप रिन्यू करा आणि आपली फिटनेस जर्नी सुरू ठेवा.

💪 *रिन्यू करण्यासाठी लगेच भेट द्या!*

धन्यवाद,
KP GYM टीम
''';
    } else {
      return '''
🏋️‍♂️ *KP GYM* 🏋️‍♂️

नमस्कार ${member.name},

आपले जिम मेंबरशिप $daysLeft दिवसांमध्ये संपत आहे (${_formatDate(expiryDate)}).

कृपया आपले मेंबरशिप रिन्यू करा आणि आपली फिटनेस जर्नी सुरू ठेवा.

💪 *रिन्यू करण्यासाठी लवकरच भेट द्या!*

धन्यवाद,
KP GYM टीम
''';
    }
  }
  
  // Get welcome message in Marathi
  static String getWelcomeMessageMarathi(Member member) {
    return '''
🏋️‍♂️ *KP GYM मध्ये आपले स्वागत आहे!* 🏋️‍♂️

नमस्कार ${member.name},

KP GYM मध्ये आपले स्वागत आहे! आपली फिटनेस जर्नी आजपासून सुरू होत आहे.

📝 *तुमची माहिती:*
• जॉइनिंग तारीख: ${_formatDate(member.joiningDate)}
• एक्सपायरी तारीख: ${_formatDate(member.expiryDate)}
• शिफ्ट: ${member.isMorningShift ? 'सकाळी' : 'संध्याकाळी'}

🕒 *जिम टाइमिंग:*
• सकाळी: 5:00 AM - 10:00 AM
• संध्याकाळी: 5:00 PM - 10:00 PM

💪 आपल्या फिटनेस गोलसाठी आम्ही आपल्या सोबत आहोत!

धन्यवाद,
KP GYM टीम
''';
  }
  
  // Get birthday message in Marathi
  static String getBirthdayMessageMarathi(String memberName) {
    return '''
🎉 *वाढदिवसाच्या हार्दिक शुभेच्छा!* 🎉

प्रिय $memberName,

आपल्या वाढदिवसाच्या हार्दिक शुभेच्छा! 🎂

आपला हा नवा वर्ष आरोग्य, संपत्ती आणि खुशीने भरलेला असो. आपली फिटनेस जर्नी यशस्वी होवो!

💪 आपल्या सुंदर भविष्यासाठी शुभकामना!

KP GYM परिवाराकडून प्रेमपूर्वक शुभेच्छा,
KP GYM टीम
''';
  }
  
  // Format date helper
  static String _formatDate(DateTime date) {
    final months = [
      'जानेवारी', 'फेब्रुवारी', 'मार्च', 'एप्रिल', 'मे', 'जून',
      'जुलै', 'ऑगस्ट', 'सप्टेंबर', 'ऑक्टोबर', 'नोव्हेंबर', 'डिसेंबर'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}