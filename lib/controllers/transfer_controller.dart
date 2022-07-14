import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/config.dart';
import 'package:baschack/models/payment_user.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:dio/dio.dart' as d;
import '../models/transaction.dart';
import '../models/transfer.dart';

class TransferController extends ResourceController {
  ManagedContext context;
  Config config;
  TransferController(this.context, this.config);
  @Operation.get()
  Future<Response> transfers() async {
    final List<String> txsStandAlone = [];
    final List<String> txsCards = [];
    final aloneTxsQuery = Query<Transaction>(context)..where((i) => i.user!.id).equalTo(request!.authorization!.ownerID);
    final aloneTxs = await aloneTxsQuery.fetch();
    txsStandAlone.addAll(aloneTxs.map((e) => e.blockchainIdentitatis!));
    final boughtsQuery = Query<PaymentUser>(context)
      ..where((i) => i.user!.id).equalTo(request!.authorization!.ownerID);
    final boughts = await boughtsQuery.fetch();
    txsCards.addAll(boughts.map((b) => b.transaction!));
    final resches = [];
    for (int i = 0; i < txsCards.length; i++) {
      try {
        final txInfo = await d.Dio().get('${config.gladiatorsurl}/transaction/${txsCards[i]}'); 
        if (txInfo.data['data']['confirmationes'].toString() != 'null') {
          if(int.parse(txInfo.data['data']['confirmationes'].toString()) > config.confirmations!) {
              final isGivenQuery = Query<PaymentUser>(context)
                ..where((x) => x.transaction).isNotNull()
                ..where((x) => x.transaction).equalTo(txsCards[i]);
              final isGiven = await isGivenQuery.fetchOne();
              if (!isGiven!.isConfirmed!) {
                final paymentsQuery = Query<PaymentUser>(context)
                  ..where((x) => x.transaction).isNotNull()
                  ..where((x) => x.transaction).equalTo(txsCards[i])
                  ..values.isConfirmed = true;
                final payment = await paymentsQuery.updateOne();
                final paschayQuery = Query<PaymentUser>(context)
                  ..where((x) => x.transaction).isNotNull()
                  ..where((x) => x.transaction).equalTo(txsCards[i])
                  ..where((x) => x.isConfirmed).equalTo(true)
                  ..join(object: (x) => x.user)
                  ..join(object: (x) => x.payment).join(object: (x) => x.card);
                final paschay = await paschayQuery.fetchOne();
                final cardUserQuery = Query<CardUser>(context)
                  ..values.user = paschay!.user
                  ..values.card = paschay.payment!.card!;
                await cardUserQuery.insert();
              }

          }  
        }
        resches.add(txInfo.data);
      } on d.DioError catch (e) {}
    }
    for (int i = 0; i < txsStandAlone.length; i++) {
      try {
        final txInfo = await d.Dio().get('${config.gladiatorsurl}/transaction/${txsStandAlone[i]}');
        resches.add(txInfo.data);
      } on d.DioError catch (err) { }
    }
    return Response.ok(resches);
  }
  @Operation.post()
  Future<Response> transfer(@Bind.body() Transfer transfer) async {
    final userQuery = Query<User>(context)..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final user = await userQuery.fetchOne();
    try {
      final tx = await d.Dio().post('${config.gladiatorsurl}/transaction-fixum', data: {
        "from": user!.private!,
        "to": transfer.to!,
        "gla": transfer.amount.toString()
      });
      final txQuery = Query<Transaction>(context)
        ..values.blockchainIdentitatis = tx.data['transactionIdentitatis'].toString()
        ..values.user = user;
      final transaction = await txQuery.insert();
    } on d.DioError catch (err) {
      return Response.badRequest(body: err.response?.data);
    }
    return Response.ok("");
  }
}