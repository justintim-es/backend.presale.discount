import 'dart:async';
import 'package:conduit/conduit.dart';   

class Migration19 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_CardPurchase", [SchemaColumn("cardPurchaseId", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("amount", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.addColumn("_CardPurchase", SchemaColumn.relationship("shop", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_CardPurchase", SchemaColumn.relationship("card", ManagedPropertyType.bigInteger, relatedTableName: "_Card", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_CardPurchase", SchemaColumn.relationship("shopper", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_User", SchemaColumn("jaguarSecret", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    