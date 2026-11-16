import 'package:equatable/equatable.dart';
import '../../../../../../data/models/auth/customer_register_request.dart';

abstract class CustomerRegisterEvent extends Equatable {
  const CustomerRegisterEvent();

  @override
  List<Object?> get props => [];
}

class CustomerRegisterSubmitted extends CustomerRegisterEvent {
  final CustomerRegisterRequest request;

  const CustomerRegisterSubmitted(this.request);

  @override
  List<Object?> get props => [request];
}

