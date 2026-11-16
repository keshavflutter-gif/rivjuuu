import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for managing user authentication tokens and user session data.
///
/// NOTE ON SECURITY:
/// While [SharedPreferences] is used here as requested by project specifications,
/// for production security hardening, storing sensitive credentials (especially JWT
/// [accessToken] and [refreshToken]) inside FlutterSecureStorage (Keychain on iOS
/// and EncryptedSharedPreferences/Keystore on Android) is strongly recommended.
class TokenStorageService {
  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUserId = 'auth_user_id';
  static const String _keyEmail = 'auth_user_email';
  static const String _keyFirstName = 'auth_user_first_name';
  static const String _keyLastName = 'auth_user_last_name';
  static const String _keyDisplayName = 'auth_user_display_name';
  static const String _keyPhone = 'auth_user_phone';
  static const String _keyRole = 'auth_user_role';
  static const String _keyStatus = 'auth_user_status';
  static const String _keyCustomerProfileId = 'auth_customer_profile_id';
  static const String _keyAvatarUrl = 'auth_customer_avatar_url';
  static const String _keyBio = 'auth_customer_bio';

  static TokenStorageService? _instance;
  final SharedPreferences? _prefs;

  TokenStorageService._internal(this._prefs);

  /// Resets singleton instance (useful for unit/widget tests).
  static void resetForTesting() {
    _instance = null;
  }

  static Future<TokenStorageService> getInstance({SharedPreferences? prefs}) async {
    if (prefs != null) {
      _instance = TokenStorageService._internal(prefs);
      return _instance!;
    }
    if (_instance == null) {
      final sp = await SharedPreferences.getInstance();
      _instance = TokenStorageService._internal(sp);
    }
    return _instance!;
  }

  Future<SharedPreferences> _getPrefs() async {
    if (_prefs != null) return _prefs;
    return SharedPreferences.getInstance();
  }

  /// Saves the complete customer authenticated session.
  /// Does NOT save password or confirmPassword.
  /// Never prints tokens to console logs.
  Future<bool> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    required String displayName,
    String? phone,
    required String role,
    required String status,
  }) async {
    if (accessToken.trim().isEmpty || refreshToken.trim().isEmpty) {
      return false;
    }

    final prefs = await _getPrefs();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyFirstName, firstName);
    await prefs.setString(_keyLastName, lastName);
    await prefs.setString(_keyDisplayName, displayName);
    if (phone != null && phone.isNotEmpty) {
      await prefs.setString(_keyPhone, phone);
    } else {
      await prefs.remove(_keyPhone);
    }
    await prefs.setString(_keyRole, role);
    await prefs.setString(_keyStatus, status);

    return true;
  }

  /// Saves complete authenticated login session including customer profile details.
  /// Safely handles nulls and does NOT store passwords.
  Future<bool> saveLoginSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    required String role,
    required String status,
    String? customerProfileId,
    String? displayName,
    String? avatarUrl,
    String? bio,
  }) async {
    if (accessToken.trim().isEmpty || refreshToken.trim().isEmpty) {
      return false;
    }

    final prefs = await _getPrefs();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyEmail, email);

    if (firstName != null && firstName.isNotEmpty) {
      await prefs.setString(_keyFirstName, firstName);
    } else {
      await prefs.remove(_keyFirstName);
    }

    if (lastName != null && lastName.isNotEmpty) {
      await prefs.setString(_keyLastName, lastName);
    } else {
      await prefs.remove(_keyLastName);
    }

    if (displayName != null && displayName.isNotEmpty) {
      await prefs.setString(_keyDisplayName, displayName);
    } else {
      await prefs.remove(_keyDisplayName);
    }

    if (phone != null && phone.isNotEmpty) {
      await prefs.setString(_keyPhone, phone);
    } else {
      await prefs.remove(_keyPhone);
    }

    await prefs.setString(_keyRole, role);
    await prefs.setString(_keyStatus, status);

    if (customerProfileId != null && customerProfileId.isNotEmpty) {
      await prefs.setString(_keyCustomerProfileId, customerProfileId);
    } else {
      await prefs.remove(_keyCustomerProfileId);
    }

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      await prefs.setString(_keyAvatarUrl, avatarUrl);
    } else {
      await prefs.remove(_keyAvatarUrl);
    }

    if (bio != null && bio.isNotEmpty) {
      await prefs.setString(_keyBio, bio);
    } else {
      await prefs.remove(_keyBio);
    }

    return true;
  }

  Future<String?> getAccessToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyRefreshToken);
  }

  Future<String?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyUserId);
  }

  Future<String?> getEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyEmail);
  }

  Future<String?> getDisplayName() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyDisplayName);
  }

  Future<void> updateDisplayName(String displayName) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyDisplayName, displayName);
  }

  Future<Map<String, String?>> getUserData() async {
    final prefs = await _getPrefs();
    return {
      'userId': prefs.getString(_keyUserId),
      'email': prefs.getString(_keyEmail),
      'firstName': prefs.getString(_keyFirstName),
      'lastName': prefs.getString(_keyLastName),
      'displayName': prefs.getString(_keyDisplayName),
      'phone': prefs.getString(_keyPhone),
      'role': prefs.getString(_keyRole),
      'status': prefs.getString(_keyStatus),
      'customerProfileId': prefs.getString(_keyCustomerProfileId),
      'avatarUrl': prefs.getString(_keyAvatarUrl),
      'bio': prefs.getString(_keyBio),
    };
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.trim().isNotEmpty;
  }

  /// Clears user session on logout or invalid session.
  Future<void> clearSession() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyDisplayName);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyStatus);
    await prefs.remove(_keyCustomerProfileId);
    await prefs.remove(_keyAvatarUrl);
    await prefs.remove(_keyBio);
  }
}

