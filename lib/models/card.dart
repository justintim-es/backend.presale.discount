import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/payment.dart';
import 'package:baschack/models/payment_user.dart';
import 'package:baschack/models/redeem.dart';
import 'package:conduit/conduit.dart';
class Card extends ManagedObject<_Card> implements _Card {}
class _Card {
  @primaryKey
  int? id;

  int? value;

  int? discount;

  ManagedSet<CardUser>? users;

  ManagedSet<Payment>? payments;

  ManagedSet<Redeem>? redeems;
}