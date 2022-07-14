import 'dart:async';

import 'package:conduit/conduit.dart';
import 'package:baschack/baschack.dart';
class PasswordVerifier extends AuthValidator {
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) {
    if (!isPasswordCorrect(authorizationData)) {
      return null;
    }

    return Authorization(null, authorizationData.username, this);
  }
}