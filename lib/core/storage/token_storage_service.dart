import 'package:shared_preferences/shared_preferences.dart';
import '../../features/restaurant_registration/models/restaurant_registration_data.dart';

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
  static const String _keyRestaurantId = 'auth_restaurant_id';
  static const String _keyRestaurantName = 'auth_restaurant_name';
  static const String _keyRestaurantCategory = 'auth_restaurant_category';
  static const String _keyRestaurantCategoryId = 'auth_restaurant_category_id';
  static const String _keyRestaurantAddress = 'auth_restaurant_address';
  static const String _keyRestaurantCity = 'auth_restaurant_city';
  static const String _keyRestaurantApprovalStatus = 'auth_restaurant_approval_status';

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

  /// Saves complete authenticated login session including customer or restaurant details.
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
    String? restaurantId,
    String? restaurantName,
    String? restaurantCategory,
    String? restaurantCategoryId,
    String? restaurantAddress,
    String? restaurantCity,
    String? restaurantApprovalStatus,
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

    if (restaurantId != null && restaurantId.isNotEmpty) {
      await prefs.setString(_keyRestaurantId, restaurantId);
    } else {
      await prefs.remove(_keyRestaurantId);
    }

    if (restaurantName != null && restaurantName.isNotEmpty) {
      await prefs.setString(_keyRestaurantName, restaurantName);
    } else {
      await prefs.remove(_keyRestaurantName);
    }

    if (restaurantCategory != null && restaurantCategory.isNotEmpty) {
      await prefs.setString(_keyRestaurantCategory, restaurantCategory);
    } else {
      await prefs.remove(_keyRestaurantCategory);
    }

    if (restaurantCategoryId != null && restaurantCategoryId.isNotEmpty) {
      await prefs.setString(_keyRestaurantCategoryId, restaurantCategoryId);
    } else {
      await prefs.remove(_keyRestaurantCategoryId);
    }

    if (restaurantAddress != null && restaurantAddress.isNotEmpty) {
      await prefs.setString(_keyRestaurantAddress, restaurantAddress);
    } else {
      await prefs.remove(_keyRestaurantAddress);
    }

    if (restaurantCity != null && restaurantCity.isNotEmpty) {
      await prefs.setString(_keyRestaurantCity, restaurantCity);
    } else {
      await prefs.remove(_keyRestaurantCity);
    }

    if (restaurantApprovalStatus != null && restaurantApprovalStatus.isNotEmpty) {
      await prefs.setString(_keyRestaurantApprovalStatus, restaurantApprovalStatus);
    } else {
      await prefs.remove(_keyRestaurantApprovalStatus);
    }

    return true;
  }

  /// Saves or updates restaurant details in storage.
  Future<void> saveRestaurantData(RestaurantRegistrationData data) async {
    final prefs = await _getPrefs();
    if (data.restaurantId != null && data.restaurantId!.isNotEmpty) {
      await prefs.setString(_keyRestaurantId, data.restaurantId!);
    }
    if (data.restaurantName.isNotEmpty) {
      await prefs.setString(_keyRestaurantName, data.restaurantName);
    }
    if (data.category.isNotEmpty) {
      await prefs.setString(_keyRestaurantCategory, data.category);
    }
    if (data.categoryId.isNotEmpty) {
      await prefs.setString(_keyRestaurantCategoryId, data.categoryId);
    }
    if (data.address.isNotEmpty) {
      await prefs.setString(_keyRestaurantAddress, data.address);
    }
    if (data.city.isNotEmpty) {
      await prefs.setString(_keyRestaurantCity, data.city);
    }
    if (data.approvalStatus != null && data.approvalStatus!.isNotEmpty) {
      await prefs.setString(_keyRestaurantApprovalStatus, data.approvalStatus!);
    }
    if (data.ownerName.isNotEmpty) {
      await prefs.setString(_keyDisplayName, data.ownerName);
    }
    if (data.email.isNotEmpty) {
      await prefs.setString(_keyEmail, data.email);
    }
  }

  /// Retrieves the stored restaurant registration data.
  Future<RestaurantRegistrationData> getRestaurantData() async {
    final prefs = await _getPrefs();
    final firstName = prefs.getString(_keyFirstName) ?? '';
    final lastName = prefs.getString(_keyLastName) ?? '';
    final displayName = prefs.getString(_keyDisplayName);
    final ownerName = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : '$firstName $lastName'.trim();

    return RestaurantRegistrationData(
      ownerName: ownerName,
      email: prefs.getString(_keyEmail) ?? '',
      restaurantName: prefs.getString(_keyRestaurantName) ?? '',
      category: prefs.getString(_keyRestaurantCategory) ?? '',
      categoryId: prefs.getString(_keyRestaurantCategoryId) ?? '',
      address: prefs.getString(_keyRestaurantAddress) ?? '',
      city: prefs.getString(_keyRestaurantCity) ?? 'Budapest',
      restaurantId: prefs.getString(_keyRestaurantId),
      approvalStatus: prefs.getString(_keyRestaurantApprovalStatus) ?? 'PENDING',
    );
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
      'restaurantId': prefs.getString(_keyRestaurantId),
      'restaurantName': prefs.getString(_keyRestaurantName),
      'restaurantCategory': prefs.getString(_keyRestaurantCategory),
      'restaurantCategoryId': prefs.getString(_keyRestaurantCategoryId),
      'restaurantAddress': prefs.getString(_keyRestaurantAddress),
      'restaurantCity': prefs.getString(_keyRestaurantCity),
      'restaurantApprovalStatus': prefs.getString(_keyRestaurantApprovalStatus),
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
    await prefs.remove(_keyRestaurantId);
    await prefs.remove(_keyRestaurantName);
    await prefs.remove(_keyRestaurantCategory);
    await prefs.remove(_keyRestaurantCategoryId);
    await prefs.remove(_keyRestaurantAddress);
    await prefs.remove(_keyRestaurantCity);
    await prefs.remove(_keyRestaurantApprovalStatus);
  }
}

