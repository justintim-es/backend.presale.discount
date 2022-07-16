import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration21 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Redeem", [SchemaColumn("redeemId", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("value", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.addColumn("_Redeem", SchemaColumn.relationship("card", ManagedPropertyType.bigInteger, relatedTableName: "_Card", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_Redeem", SchemaColumn.relationship("user", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_Redeem", SchemaColumn.relationship("shop", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.deleteTable("_CardPurchase");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    