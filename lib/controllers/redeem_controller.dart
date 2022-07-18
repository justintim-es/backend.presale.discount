import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/redeem.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../models/card.dart';
import '../models/jwt.dart';

class RedeemController extends ResourceController {
  final ManagedContext context;
  RedeemController(this.context);
  @Operation.post('jwt', 'amount')
  Future<Response> redeem(@Bind.path('jwt') String jwt, @Bind.path('amount') int amount) async {
    final isJwtFreeQuery = Query<JWT>(context)..where((i) => i.used).equalTo(jwt);
    final isJwt = await isJwtFreeQuery.fetchOne();
    if (isJwt != null) {
      return Response.badRequest(body: "token already used please create a new one");
    }
    final shopQuery = Query<User>(context)..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final shop = await shopQuery.fetchOne();
    final claim = verifyJwtHS256Signature(jwt, shop!.jaguarSecret!);
    final cardsUsersQuery = Query<CardUser>(context)
      ..where((x) => x.user!.id).equalTo(claim['shopper'] as int)
      ..where((x) => x.card!.id).equalTo(claim['cardId'] as int)
      ..join(object: (cu) => cu.card);
    final cardsUsers = await cardsUsersQuery.fetch();
    final redeemsQuery = Query<Redeem>(context)
      ..where((x) => x.card!.id).equalTo(claim['cardId'] as int)
      ..where((x) => x.user!.id).equalTo(claim['shopper'] as int);
    final redeems = await redeemsQuery.fetch();
    int estimated = calculateEstimated(cardsUsers, redeems);
    if (estimated >= amount) {
      final cardQuery = Query<Card>(context)..where((i) => i.id).equalTo(claim['cardId'] as int);
      final card = await cardQuery.fetchOne();
      int cardBalance = card!.value!;
      for (int i = 0; i < redeems.length; i++) {
      	if (redeems[i].card!.id == card.id) {
      		cardBalance -= redeems[i].value!;
      	} 
      }
      if(cardBalance > amount) {
    		final insertRedeemQuery = Query<Redeem>(context)
          ..values.card!.id = claim['cardId'] as int
          ..values.user!.id =  claim['shopper'] as int
          ..values.shop!.id = request!.authorization!.ownerID
          ..values.value = amount;
        await insertRedeemQuery.insert();
        final jwtQuery = Query<JWT>(context)..values.used = jwt;
        await jwtQuery.insert();
      	
      } else {
	    return Response.badRequest(body: "insufficient funds please scan different card");  	
      }
      return Response.ok("");
    }
    return Response.badRequest(body: "insufficient funds please scan different card");
  }
  int calculateEstimated(List<CardUser> cardsUsers, List<Redeem> redeems) {
    int estimated = 0;
    for (int i = 0; i < cardsUsers.length; i++) {
      estimated += cardsUsers[i].card!.value!;
    }
    for (int i = 0; i < redeems.length; i++) {
      estimated -= redeems[i].value!;
    }
    return estimated;
  }
  @Operation.get('jwt')
  Future<Response> redeemed(@Bind.path('jwt') String jwt) async {
    final jwtQuery = Query<JWT>(context)..where((i) => i.used).equalTo(jwt);
    final jwtDb = await jwtQuery.fetchOne();
    if(jwtDb == null) {
      return Response.noContent();
    } else {
      return Response.ok({});
    }
  }
}
