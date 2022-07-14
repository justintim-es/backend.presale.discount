import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration13 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Payment", SchemaColumn.relationship("card", ManagedPropertyType.bigInteger, relatedTableName: "_Card", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    