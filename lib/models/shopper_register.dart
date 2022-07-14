import 'package:conduit/conduit.dart';
class ShopperRegister extends Serializable {
    String? email;
    String? firstPassword;
    String? secondPassword;
    int? cardId;
    String? subdomain;

  @override
  Map<String, dynamic> asMap() => {
    'email': email,
    'firstPassword': firstPassword,
    'secondPassword': secondPassword,
    'cardId': cardId,
    'subdomain': subdomain
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    email = object['email'].toString();
    firstPassword = object['firstPassword'].toString();
    secondPassword = object['secondPassword'].toString();
    cardId = int.parse(object['cardId'].toString());
    subdomain = object['subdomain'].toString();
  }
}