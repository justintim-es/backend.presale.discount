import 'package:conduit/conduit.dart';
class CardIn extends Serializable {
  int? value;
  int? discount;

  @override
  Map<String, dynamic> asMap() => {
    'value': value,
    'discount': discount
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    value = int.parse(object['value'].toString());
    discount = int.parse(object['discount'].toString());
  }
  
}