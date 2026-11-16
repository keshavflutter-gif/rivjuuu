import 'package:equatable/equatable.dart';

/// Strongly typed request model for the Logout API.
///
/// Sends:
/// ```json
/// {
///   "deviceToken": ""
/// }
/// ```
class LogoutRequest extends Equatable {
  final String deviceToken;

  const LogoutRequest({
    this.deviceToken = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceToken': deviceToken,
    };
  }

  @override
  List<Object?> get props => [deviceToken];
}

