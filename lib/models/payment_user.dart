import 'package:baschack/models/card.dart';
import 'package:baschack/models/payment.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';

class PaymentUser extends ManagedObject<_PaymentUser> implements _PaymentUser {}

class _PaymentUser {
    @primaryKey
    int? paymentUserId;

    bool? outgoing;

    String? transaction;
    @Column(defaultValue: 'false')
    bool? isConfirmed;

    @Relate(#payments)
    User? user;

    @Relate(#users)
    Payment? payment;

    
}