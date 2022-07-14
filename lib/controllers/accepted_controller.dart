import 'package:conduit/conduit.dart';

import '../models/user.dart';

class AcceptedController extends ResourceController {
  ManagedContext context;
  AcceptedController(this.context);

  @Operation.get('subdomain')
  Future<Response> accepted(@Bind.path('subdomain') String subdomain) async {
    final userQuery = Query<User>(context)..where((i) => i.subdomain).equalTo(subdomain);
    final user = await userQuery.fetchOne();
    return Response.ok({
      "accepted": user!.acceptedPriceGla
    });
  }
}