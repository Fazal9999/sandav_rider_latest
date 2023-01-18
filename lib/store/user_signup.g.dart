// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_signup.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserCreadentialOb on _UserCreadentialOb, Store {
  final _$isPasswordRemberAtom =
      Atom(name: '_UserCreadentialOb.isPasswordRember');

  @override
  bool get isPasswordRember {
    _$isPasswordRemberAtom.reportRead();
    return super.isPasswordRember;
  }

  @override
  set isPasswordRember(bool value) {
    _$isPasswordRemberAtom.reportWrite(value, super.isPasswordRember, () {
      super.isPasswordRember = value;
    });
  }

  final _$isRemberLoginAtom = Atom(name: '_UserCreadentialOb.isRemberLogin');

  @override
  bool get isRemberLogin {
    _$isRemberLoginAtom.reportRead();
    return super.isRemberLogin;
  }

  @override
  set isRemberLogin(bool value) {
    _$isRemberLoginAtom.reportWrite(value, super.isRemberLogin, () {
      super.isRemberLogin = value;
    });
  }

  final _$_UserCreadentialObActionController =
      ActionController(name: '_UserCreadentialOb');

  @override
  void changeUserLoginInfo(bool chekedValue) {
    final _$actionInfo = _$_UserCreadentialObActionController.startAction(
        name: '_UserCreadentialOb.changeUserLoginInfo');
    try {
      return super.changeUserLoginInfo(chekedValue);
    } finally {
      _$_UserCreadentialObActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeRember(bool checked_value) {
    final _$actionInfo = _$_UserCreadentialObActionController.startAction(
        name: '_UserCreadentialOb.changeRember');
    try {
      return super.changeRember(checked_value);
    } finally {
      _$_UserCreadentialObActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isPasswordRember: ${isPasswordRember},
isRemberLogin: ${isRemberLogin}
    ''';
  }
}
