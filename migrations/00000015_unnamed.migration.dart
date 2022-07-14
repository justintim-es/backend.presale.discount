import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration15 extends Migration { 
  @override
  Future upgrade() async {
   		database.deleteColumn("_Payment", "card");
		database.addColumn("_PaymentUser", SchemaColumn.relationship("card", ManagedPropertyType.bigInteger, relatedTableName: "_Card", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    