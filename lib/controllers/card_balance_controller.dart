import 'package:baschack/models/card.dart';
import 'package:baschack/models/card_user.dart';
import 'package:conduit/conduit.dart';
class CardBalanceController extends ResourceController {
    ManagedContext context;
    CardBalanceController(this.context);

    @Operation.get('subdomain') 
    Future<Response> subdomain(@Bind.path('subdomain') String subdomain) async {
      final cardsUserQuery = Query<CardUser>(context)..where((x) => x.user!.id).equalTo(request!.authorization!.ownerID);
      final cardsUser = await cardsUserQuery.fetch();
      for (int i = 0; i < cardsUser.length; i++) {
        final cardQuery = Query<Card>(context)..where((x) => x.id).equalTo(cardsUser[i].card!.id);  
        cardsUser[i].card = await cardQuery.fetchOne();
      }
    }
}