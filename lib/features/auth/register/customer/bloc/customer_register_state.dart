import 'package:equatable/equatable.dart';
import '../../../../../../data/models/auth/customer_register_response.dart';

abstract class CustomerRegisterState extends Equatable {
  const CustomerRegisterState();

  @override
  List<Object?> get props => [];
}

class CustomerRegisterInitial extends CustomerRegisterState {
  const CustomerRegisterInitial();
}

class CustomerRegisterLoading extends CustomerRegisterState {
  const CustomerRegisterLoading();
}

class CustomerRegisterSuccess extends CustomerRegisterState {
  final CustomerRegisterResponse response;
  final String message;

  const CustomerRegisterSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

class CustomerRegisterFailure extends CustomerRegisterState {
  final String message;
  final Map<String, String>? fieldErrors;

  const CustomerRegisterFailure({
    required this.message,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, fieldErrors];
}

