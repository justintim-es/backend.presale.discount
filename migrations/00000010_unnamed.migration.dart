import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration10 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_User", SchemaColumn("acceptedPriceGla", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    