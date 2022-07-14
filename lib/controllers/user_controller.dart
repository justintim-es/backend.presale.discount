import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';

class UserController extends ResourceController {
  ManagedContext context;
  UserController(this.context);

  @Operation.get()
  Future<Response> type() async {
    final userQuery = Query<User>(context)
      ..where((x) => x.id).equalTo(request!.authorization!.ownerID);
    final user = await userQuery.fetchOne();
    return Response.ok({ "type": user!.uschus!.index });
  }
}