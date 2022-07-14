
import 'dart:async';

import 'package:baschack/models/card_purchase.dart';
import 'package:baschack/models/collect.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class CardPurchaseController extends ResourceController {
  ManagedContext context;
  CardPurchaseController(this.context);

  @Operation.post()
  Future<Response> collect(@Bind.body() Collect collect) async {
    final shopQuery = Query<User>(context)..where((x) => x.id).equalTo(request!.authorization!.ownerID);
    final shop = await shopQuery.fetchOne();
    final JwtClaim claim = verifyJwtHS256Signature(collect.encryptedCustomer!, shop!.jaguarSecret!);
    final cardPurchaseQuery = Query<CardPurchase>(context)
      ..values.shop = shop
      ..values.card!.id = collect.card!
      ..values.shopper!.id = int.parse(claim['shopper'].toString());
    return Response.ok("");
  }
  @Operation.get('cardId', 'subdomain') 
  Future<Response> encrypt(@Bind.path('cardId') int cardId, @Bind.path('subdomain') String subdomain) async {
    final shopQuery = Query<User>(context)..where((x) => x.subdomain).equalTo(subdomain);
    final shop = await shopQuery.fetchOne();
    final claim = JwtClaim(otherClaims: {
      "shopper": request!.authorization!.ownerID,
      "cardId": cardId
    }, maxAge: const Duration(minutes: 5));
    String token = issueJwtHS256(claim, shop!.jaguarSecret!);
    return Response.ok({
      "token": token
    });
  }
}