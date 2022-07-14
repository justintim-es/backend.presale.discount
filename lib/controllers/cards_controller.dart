import 'package:baschack/models/card.dart';
import 'package:baschack/models/card_in.dart';
import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';

class CardsController extends ResourceController {
    ManagedContext context;
    CardsController(this.context);
    @Operation.post()
    Future<Response> create(@Bind.body() CardIn cardIn) async {
      if (cardIn.discount! >= cardIn.value!) {
        return Response.badRequest(body: {
          "error": "Discount should be smaller than amount"
        });
      }
      final cardQuery = Query<Card>(context)  
        ..values.discount = cardIn.discount
        ..values.value = cardIn.value;
      final card = await cardQuery.insert();
      final cardUserQuery = Query<CardUser>(context)
        ..values.card!.id = card.id
        ..values.user!.id = request!.authorization!.ownerID;
      await cardUserQuery.insert();
      return Response.ok("");
    }
    @Operation.get()
    Future<Response> cards() async {
      final cardUserQuery = Query<CardUser>(context)
        ..join(object: (ob) => ob.card).returningProperties((x) => [x.discount, x.value, x.id])
        ..where((cu) => cu.user!.id).equalTo(request!.authorization!.ownerID);
      final cards = await cardUserQuery.fetch();
      List<CardUser> owners = [];
      for (int i = 0; i < cards.length; i++) {
        final cardOwnerQuery = Query<CardUser>(context)
          ..join(object: (u) => u.user).returningProperties((x) => [x.subdomain])
          ..where((i) => i.card!.id).equalTo(cards[i].card! .id)
          ..where((i) => i.user!.uschus).equalTo(Uschus.shop);
        final cardOwner = await cardOwnerQuery.fetchOne();
        cards[i].user = cardOwner!.user;
      }
      return Response.ok(cards);
    }
    @Operation.get('subdomain')
    Future<Response> subCards(@Bind.path('subdomain') String subdomain) async {
      final cardQuery = Query<Card>(context);
      cardQuery
      .join(set: (c) => c.users)
      .where((ca) => ca.user!.subdomain)
      .equalTo(subdomain);
      final cards = await cardQuery.fetch();
      cards.forEach((e) => e.removePropertiesFromBackingMap(['id', 'user']));
      return Response.ok(cards);
    }
} 