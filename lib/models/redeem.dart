import 'package:baschack/models/card.dart';
import 'package:conduit/conduit.dart';
import 'package:baschack/models/user.dart';
class Redeem extends ManagedObject<_Redeem> implements _Redeem {}

class _Redeem {
  @primaryKey
  int? redeemId;
  @Relate(#redeems)
  Card? card;
  @Relate(#purchases)
  User? user;
  @Relate(#redeems)
  User? shop;

  int? value;
}