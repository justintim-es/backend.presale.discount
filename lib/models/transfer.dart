import 'package:conduit/conduit.dart';
class Transfer extends Serializable {
    String? to;
    BigInt? amount;

  @override
  Map<String, dynamic> asMap() => {
    'to': to,
    'amount': amount.toString()
  };
  @override
  void readFromMap(Map<String, dynamic> object) {
    to = object['to'].toString();
    amount = BigInt.parse(object['amount'].toString());
  } 
}