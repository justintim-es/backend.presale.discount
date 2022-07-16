
import 'dart:async';
import 'package:baschack/models/collect.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class CardPurchaseController extends ResourceController {
  ManagedContext context;
  CardPurchaseController(this.context);


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