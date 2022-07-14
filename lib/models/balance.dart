
import 'package:baschack/models/card.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
class Bought extends ManagedObject<_Bought> implements _Bought {}

class _Bought {
  @primaryKey
  int? balanceId;
  
  ManagedSet<Card>? card;
}