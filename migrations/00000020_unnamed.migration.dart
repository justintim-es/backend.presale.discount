import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration20 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_JWT", [SchemaColumn("used", ManagedPropertyType.string, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    