part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthRegister extends AuthEvent {
  final String username;
  final String password;
  final String domain;
  final String accountName;
  final String typeLogin; //xtreme or m3u
  final bool addToPlayList;

  AuthRegister(this.username, this.password, this.domain, this.accountName,
      {this.addToPlayList = true, required this.typeLogin});
}

class AuthGetUser extends AuthEvent {}

class DeleteUserEvent extends AuthEvent {
  final String accountName;

  DeleteUserEvent({required this.accountName});
}

class AuthLogOut extends AuthEvent {
  final String? accountName;

  AuthLogOut({this.accountName});
}
