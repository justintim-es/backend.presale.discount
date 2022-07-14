import 'package:conduit/conduit.dart';
class Collect extends Serializable {
    String? encryptedCustomer;
    int? card;

  @override
  Map<String, dynamic> asMap() => {
    'encryptedCustomer': encryptedCustomer,
    'card': card
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    encryptedCustomer = object['encryptedCustomer'].toString();
    card = int.parse(['card'].toString());
  } 
}