import 'package:baschack/models/card.dart';
import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/config.dart';
import 'package:baschack/models/payment.dart';
import 'package:baschack/models/payment_user.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:dio/dio.dart' as d;
import 'dart:math';

class BuyController extends ResourceController {
  ManagedContext context;
  Config config;
  BuyController(this.context, this.config);
  @Operation.post('cardId', 'subdomain')
  Future<Response> buy(@Bind.path('cardId') int cardId, @Bind.path('subdomain') String subdomain) async {
    final buyerQuery = Query<User>(context)..where((x) => x.id).equalTo(request!.authorization!.ownerID);
    final buyer = await buyerQuery.fetchOne();
    final shopQuery = Query<User>(context)..where((x) => x.subdomain).equalTo(subdomain);
    final shop = await shopQuery.fetchOne();
    final keypair = await d.Dio().get('${config.gladiatorsurl}/rationem');    
    final cardQuery = Query<Card>(context)..where((i) => i.id).equalTo(cardId);
    final card = await cardQuery.fetchOne();
    final paymentQuery = Query<Payment>(context)
      ..values.private = keypair.data['privatusClavis'].toString()
      ..values.public = keypair.data['publicaClavis'].toString()
      ..values.card = card;
    final payment = await paymentQuery.insert();
    final euro = card!.value! - card.discount!;
    final gla = (euro * 100) / shop!.acceptedPriceGla!;
    final parseable = gla * pow(10, gla.toString().length);
    final reschet = BigInt.from(parseable) * BigInt.from(10e+51) / BigInt.from(pow(10, gla.toString().length));
    print(reschet);
    try {
      final outgoingTx = await d.Dio().post('${config.gladiatorsurl}/transaction-fixum', data: {
        "from": buyer!.private,
        "to": keypair.data['publicaClavis'].toString(),
        "gla": reschet
      });      
      final outgoingPaymentUserQuery = Query<PaymentUser>(context)
        ..values.transaction = outgoingTx.data['transactionIdentitatis'].toString()
        ..values.outgoing = true
        ..values.user = buyer
        ..values.payment = payment;
      await outgoingPaymentUserQuery.insert();
      final incomingTx = await d.Dio().post('${config.gladiatorsurl}/transaction-fixum', data: {
        "from": payment.private,
        "to": shop.public,
        "gla": reschet
      });
      final incomingPaymentUserQuery = Query<PaymentUser>(context)
        ..values.transaction = incomingTx.data['transactionIdentitatis'].toString()
        ..values.outgoing = false
        ..values.user = shop
        ..values.payment = payment;
      await incomingPaymentUserQuery.insert();
    } on d.DioError catch (err) {
      print(err);
      return Response.badRequest(body: err.response?.data);
    }
    //return tx ids
    return Response.ok("");
  }

}