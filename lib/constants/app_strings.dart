class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'appName': 'KP GYM',
      'loading': 'Loading...',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'confirm': 'Confirm',
      'back': 'Back',
      'success': 'Success',
      'error': 'Error',

      // Shifts
      'morningShift': 'Morning Shift',
      'nightShift': 'Night Shift',
      'selectShift': 'Select Shift',

      // Members
      'members': 'Members',
      'memberDetails': 'Member Details',
      'addMember': 'Add Member',
      'editMember': 'Edit Member',
      'deleteMember': 'Delete Member',
      'memberName': 'Member Name',
      'joiningDate': 'Joining Date',
      'remainingDays': 'Remaining Days',
      'daysLeft': 'Days Left',
      'subscriptionType': 'Subscription Type',
      'subscriptionAmount': 'Amount',
      'monthlySubscription': 'Monthly (30 Days)',
      'quarterlySubscription': 'Quarterly (90 Days)',

      // Notifications & Share
      'notification': 'Notification',
      'subscriptionEnding': 'Subscription Ending',
      'subscriptionEndingMsg': 'Your subscription is ending soon.',
      'share': 'Share',
      'shareMsg':
          'Hello, your KP GYM subscription is ending in {days} days. Please renew your subscription.',
      'shareSuccess': 'Shared successfully!',
      'shareError': 'Failed to share.',

      // Reports
      'incomeReport': 'Income Report',
      'totalIncome': 'Total Income',
      'currentMonthIncome': 'Current Month Income',
      'monthlyReport': 'Monthly Report',
      'month': 'Month',
      'amount': 'Amount',

      // Confirmation Messages
      'confirmDelete': 'Are you sure you want to delete this member?',
      'memberAdded': 'Member added successfully!',
      'memberUpdated': 'Member updated successfully!',
      'memberDeleted': 'Member deleted successfully!',

      // Form Validation
      'nameRequired': 'Name is required',
      'invalidAmount': 'Invalid amount',
      'selectSubscriptionType': 'Please select subscription type',
    },
    'mr': {
      // General
      'appName': 'के.पी. जिम',
      'loading': 'लोड होत आहे...',
      'ok': 'ठीक आहे',
      'cancel': 'रद्द करा',
      'save': 'सेव्ह करा',
      'delete': 'हटवा',
      'edit': 'संपादित करा',
      'add': 'जोडा',
      'search': 'शोधा',
      'confirm': 'पुष्टी करा',
      'back': 'मागे',
      'success': 'यशस्वी',
      'error': 'त्रुटी',

      // Shifts
      'morningShift': 'सकाळची शिफ्ट',
      'nightShift': 'रात्रीची शिफ्ट',
      'selectShift': 'शिफ्ट निवडा',

      // Members
      'members': 'सदस्य',
      'memberDetails': 'सदस्य तपशील',
      'addMember': 'सदस्य जोडा',
      'editMember': 'सदस्य संपादित करा',
      'deleteMember': 'सदस्य हटवा',
      'memberName': 'सदस्याचे नाव',
      'joiningDate': 'सामील होण्याची तारीख',
      'remainingDays': 'उरलेले दिवस',
      'daysLeft': 'दिवस शिल्लक',
      'subscriptionType': 'सदस्यता प्रकार',
      'subscriptionAmount': 'रक्कम',
      'monthlySubscription': 'मासिक (३० दिवस)',
      'quarterlySubscription': 'त्रैमासिक (९० दिवस)',

      // Notifications & Share
      'notification': 'सूचना',
      'subscriptionEnding': 'सदस्यता संपत आहे',
      'subscriptionEndingMsg': 'तुमची सदस्यता लवकरच संपत आहे.',
      'share': 'शेअर करा',
      'shareMsg':
          'नमस्कार, तुमची के.पी. जिम सदस्यता {days} दिवसांमध्ये संपत आहे. कृपया तुमची सदस्यता नूतनीकरण करा.',
      'shareSuccess': 'यशस्वीरित्या शेअर केले!',
      'shareError': 'शेअर करण्यात अयशस्वी.',

      // Reports
      'incomeReport': 'उत्पन्न अहवाल',
      'totalIncome': 'एकूण उत्पन्न',
      'currentMonthIncome': 'चालू महिन्याचे उत्पन्न',
      'monthlyReport': 'मासिक अहवाल',
      'month': 'महिना',
      'amount': 'रक्कम',

      // Confirmation Messages
      'confirmDelete':
          'तुम्हाला खात्री आहे की तुम्ही या सदस्याला हटवू इच्छिता?',
      'memberAdded': 'सदस्य यशस्वीरित्या जोडला गेला!',
      'memberUpdated': 'सदस्य यशस्वीरित्या अपडेट केला गेला!',
      'memberDeleted': 'सदस्य यशस्वीरित्या हटवला गेला!',

      // Form Validation
      'nameRequired': 'नाव आवश्यक आहे',
      'invalidAmount': 'अवैध रक्कम',
      'selectSubscriptionType': 'कृपया सदस्यता प्रकार निवडा',
    },
  };

  static String get(String key, {String language = 'en'}) {
    if (_localizedValues[language]?.containsKey(key) ?? false) {
      return _localizedValues[language]![key]!;
    }

    // Fallback to English
    return _localizedValues['en']![key] ?? key;
  }

  static String formatSharedText(String text, Map<String, String> params,
      {String language = 'en'}) {
    String result = text;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
