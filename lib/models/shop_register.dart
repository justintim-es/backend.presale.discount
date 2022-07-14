import 'package:conduit/conduit.dart';
class ShopRegister extends Serializable {
  String? email;
  String? company;
  String? city;
  String? firstPassword;
  String? secondPassword;
  String? subdomain;

  @override
  Map<String, dynamic> asMap() => {
    'email': email,
    'company': company,
    'city': city,
    'firstPassword': firstPassword,
    'secondPassword': secondPassword,
    'subdomain': subdomain
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    email = object['email'].toString();
    company = object['company'].toString();
    city = object['city'].toString();
    firstPassword = object['firstPassword'].toString();
    secondPassword = object['secondPassword'].toString();
    subdomain = object['subdomain'].toString();
  }

}