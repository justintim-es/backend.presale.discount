import 'package:baschack/models/card.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
class CardPurchase extends ManagedObject<_CardPurchase> implements _CardPurchase {}
class _CardPurchase {
  @primaryKey 
  int? cardPurchaseId;

  int? amount;
  @Relate(#collections)
  User? shop;

  @Relate(#purchases)
  Card? card;

  @Relate(#purchases)
  User? shopper;
}