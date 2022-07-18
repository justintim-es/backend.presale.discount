import 'package:conduit/conduit.dart';

class ResellerIn extends Serializable {
  String? email;
  String? firstPassword;
  String? secondPassword;

  @override
  Map<String, dynamic> asMap() => {
    'email': email,
    'firstPassword': firstPassword,
    'secondPassword': secondPassword
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    email = object['email'].toString();
    firstPassword = object['firstPassword'].toString();
    secondPassword = object['secondPassword'].toString();
  }
}