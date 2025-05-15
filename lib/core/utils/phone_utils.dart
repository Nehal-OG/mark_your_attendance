class PhoneUtils {
  static const String COUNTRY_CODE = '+91';
  static const int PHONE_LENGTH = 10;

  // Format phone number to E.164 format
  static String formatPhoneNumber(String phone) {
    // Remove all non-numeric characters
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Remove country code if present at the start
    if (cleaned.startsWith('91')) {
      cleaned = cleaned.substring(2);
    }

    // Return formatted number with country code
    return COUNTRY_CODE + cleaned;
  }

  // Validate phone number
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-numeric characters for validation
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Remove country code if present
    if (cleaned.startsWith('91')) {
      cleaned = cleaned.substring(2);
    }

    // Check for non-numeric characters in original input
    if (phone.replaceAll('+', '').contains(RegExp(r'[^0-9]'))) {
      return 'Phone number should only contain numbers';
    }

    // Check length
    if (cleaned.length < PHONE_LENGTH) {
      return 'Phone number must be $PHONE_LENGTH digits';
    }

    if (cleaned.length > PHONE_LENGTH) {
      return 'Phone number cannot be more than $PHONE_LENGTH digits';
    }

    return null;
  }

  // Format for display (without country code)
  static String formatForDisplay(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('91')) {
      cleaned = cleaned.substring(2);
    }
    return cleaned;
  }

  // Check if phone number is valid
  static bool isValidPhoneNumber(String phone) {
    return validatePhoneNumber(phone) == null;
  }
} 