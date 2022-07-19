
import 'package:baschack/models/config.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:dio/dio.dart' as d;
class ResellerActivateController extends ResourceController {
  ManagedContext context;
  Config config;
  ResellerActivateController(this.context, this.config);

  @Operation.get()
  Future<Response> pay() async {
    final uq = Query<User>(context)..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final u = await uq.fetchOne();
    
    if (u!.payPublic == null) {
      final keypair = await d.Dio().get('${config.gladiatorsurl}/rationem');
      final rq = Query<User>(context)..where((u) => u.uschus).equalTo(Uschus.reseller);
      final rs = await rq.fetch();
      final BigInt requiredGla = BigInt.from((BigInt.from(1e+51) / BigInt.from(5100)));
      final kuq = Query<User>(context)
        ..values.payPrivate = keypair.data['privatusClavis'].toString()
        ..values.payPublic = keypair.data['publicaClavis'].toString()
        ..values.requestGla = requiredGla.toString()
        ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
      final uu = await kuq.updateOne();
      return Response.ok({
        "code": 0,
        "public": uu!.payPublic,
        "required": uu.requestGla
      });
    } else if (u.payTxId == null) {
      final balance = await d.Dio().get('${config.gladiatorsurl}/statera/false/${u.payPublic}');
      if (BigInt.parse(balance.data['statera'].toString()) >= BigInt.parse(u.requestGla!)) {
        final tx = await d.Dio().post('${config.gladiatorsurl}/transaction-fixum', data: {
          "from": u.payPrivate,
          "to": config.publicKey!,
          "gla": u.requestGla!
        });
        final puq = Query<User>(context)
          ..values.payTxId = tx.data['transactionIdentitatis'].toString()
          ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
        final upuq = await puq.updateOne();
      }
      return Response.ok({
        "code": 0,
        "public": u.payPublic,
        "required": u.requestGla
      });
    } else {
      final tx = await d.Dio().get('${config.gladiatorsurl}/transaction/${u.payTxId}');
      final confirmationes = tx.data['data']['confirmationes']; 
      print(tx.data);
      print(confirmationes);
      if(confirmationes != 'null') {
	      if (
     	 	BigInt.parse(confirmationes.toString()) 
      		> 
      		BigInt.from(config.confirmations!)
      		) {
        	final auq = Query<User>(context)
          		..values.isPayed = true
          		..where((i) => i.id).equalTo(request!.authorization!.ownerID);
       		await auq.updateOne();
      		}      	
      }
      return Response.ok({
        "code": 1,
        "confirmations": confirmationes
      });
    }
  }
}
