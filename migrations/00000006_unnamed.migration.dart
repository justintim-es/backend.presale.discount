import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration6 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_User", SchemaColumn("private", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
		database.addColumn("_User", SchemaColumn("public", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    