

import 'package:baschack/models/config.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:dio/dio.dart' as d;

class ResellerController extends ResourceController {
	ManagedContext context;
  ResellerController(this.context);
  @Operation.get()
  Future<Response> isPayed() async {
    final uq = Query<User>(context)..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final u = await uq.fetchOne();
    return Response.ok({ "isPayed": u!.isPayed });
  }
}
