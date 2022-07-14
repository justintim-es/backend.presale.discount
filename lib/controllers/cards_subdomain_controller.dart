import 'package:baschack/models/card.dart';
import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
class CardsSubdomainController extends ResourceController {
  ManagedContext context;
  CardsSubdomainController(this.context);
  @Operation.get('subdomain')
  Future<Response> cards(@Bind.path('subdomain') String subdomain) async {
    final shopQuery = Query<User>(context)..where((s) => s.subdomain).equalTo(subdomain);
    final shop = await shopQuery.fetchOne();
    final cardUsersQuery = Query<CardUser>(context)..where((u) => u.user!.id).equalTo(shop!.id);
    final cardUsers = await cardUsersQuery.fetch();
    final List<Card> cards = [];
    for (int i = 0; i < cardUsers.length; i++) {
      final cardQuery = Query<Card>(context)..where((c) => c.id).equalTo(cardUsers[i].card!.id);
      final card = await cardQuery.fetchOne();
      cards.add(card!);
    }
    print(cards);
    return Response.ok(cards);
  }
}