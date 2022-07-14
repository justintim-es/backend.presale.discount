import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration17 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_PaymentUser", "card");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    