import 'package:baschack/models/redeem.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';

class RedeemsController extends ResourceController {
  ManagedContext context;
  RedeemsController(this.context);
  
  @Operation.get('card')
  Future<Response> redeems(@Bind.path('card') int card) async {
    final uq = Query<User>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final u = await uq.fetchOne();
    if (u!.uschus == Uschus.shop) {
      final rq = Query<Redeem>(context)
        ..where((i) => i.card!.id).equalTo(card)
        ..where((i) => i.shop!.id).equalTo(request!.authorization!.ownerID)
        ..sortBy((x) => x.date, QuerySortOrder.descending);
      final r = await rq.fetch();
      return Response.ok(r);
    } else if (u.uschus == Uschus.shopper) {
      final rq = Query<Redeem>(context)
        ..where((i) => i.card!.id).equalTo(card)
        ..where((i) => i.user!.id).equalTo(request!.authorization!.ownerID)
        ..sortBy((x) => x.date, QuerySortOrder.descending);
      final r = await rq.fetch();
      return Response.ok(r);
    }
    return Response.badRequest();
  }
}
