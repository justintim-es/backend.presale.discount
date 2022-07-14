import 'package:baschack/models/card.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';


class CardUser extends ManagedObject<_CardUser> implements _CardUser {}
class _CardUser {
  @primaryKey
  int? cardUserId;

  @Relate(#cards)
  User? user;

  @Relate(#users)
  Card? card;
}