part of 'auth_bloc.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.authCheckResquested() = AuthCheckResquested;
  const factory AuthEvent.signedOut() = SignedOut;
}
