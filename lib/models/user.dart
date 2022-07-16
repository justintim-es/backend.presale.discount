import 'package:baschack/models/card.dart';
import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/payment_user.dart';
import 'package:baschack/models/redeem.dart';
import 'package:baschack/models/transaction.dart';
import 'package:conduit/conduit.dart';
import 'package:conduit/managed_auth.dart';

enum Uschus {
  shop,
  reseller,
  shopper
}
class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {}
class _User extends ResourceOwnerTableDefinition {
  Uschus? uschus;
  @Column(nullable: true)
  String? city;
  @Column(nullable: true)
  String? company;  
  @Column(nullable: true)
  int? acceptedPriceGla; 
  String? confirmation;
  bool? isConfirmed;
  @Column(nullable: true, unique: true)
  String? subdomain;

  String? private;
  String? public;
  String? firstPassword;
  String? secondPassword;
  @Column(nullable: true)
  DateTime? lock;
  @Column(nullable: true)
  String? jaguarSecret;
  ManagedSet<CardUser>? cards;

  ManagedSet<PaymentUser>? payments;

  ManagedSet<Transaction>? transactions;

  ManagedSet<Redeem>? redeems;

  ManagedSet<Redeem>? purchases;

}
