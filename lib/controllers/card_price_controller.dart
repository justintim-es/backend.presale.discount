import 'package:baschack/models/card.dart';
import 'package:baschack/models/config.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:dio/dio.dart' as d;
import 'dart:math';
class CardPriceController extends ResourceController {
  ManagedContext context;
  CardPriceController(this.context);
  
  @Operation.get('cardId', 'subdomain')
  Future<Response> price(@Bind.path('cardId') int cardId, @Bind.path('subdomain') String subdomain) async {
    final cardQuery = Query<Card>(context)..where((x) => x.id).equalTo(cardId);
    final card = await cardQuery.fetchOne();
    final shopQuery = Query<User>(context)..where((x) => x.subdomain).equalTo(subdomain);
    final shop = await shopQuery.fetchOne();
    final euro = card!.value! - card.discount!;
    final gla = (euro * 100) / shop!.acceptedPriceGla!;
    final parseable = gla * pow(10, gla.toString().length);
    final reschet = BigInt.from(parseable) * BigInt.from(10e+51) / BigInt.from(pow(10, gla.toString().length));
    return Response.ok({
      "gla": reschet.toString()
    });
  }
}