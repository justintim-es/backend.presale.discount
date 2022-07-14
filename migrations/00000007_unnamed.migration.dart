import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration7 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_User", "subdomain", (c) {c.isUnique = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    