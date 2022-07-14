import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration14 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_PaymentUser", SchemaColumn("isConfirmed", ManagedPropertyType.boolean, isPrimaryKey: false, autoincrement: false, defaultValue: "false", isIndexed: false, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    