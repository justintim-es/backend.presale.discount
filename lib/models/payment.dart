import 'package:baschack/models/card.dart';
import 'package:baschack/models/payment_user.dart';
import 'package:conduit/conduit.dart';
class Payment extends ManagedObject<_Payment> implements _Payment {}

class _Payment {
  @primaryKey
  int? paymentId;
  String? private;
  String? public;

  @Relate(#payments)
  Card? card;
  ManagedSet<PaymentUser>? users;
}