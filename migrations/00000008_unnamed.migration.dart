import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration8 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_User", SchemaColumn("firstPassword", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("lock", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    