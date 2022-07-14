import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
class PublicController extends ResourceController {
  ManagedContext context;
  PublicController(this.context);

  @Operation.get()
  Future<Response> get() async {
    final userQuery = Query<User>(context)..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final user = await userQuery.fetchOne();
    return Response.ok({
      "public": user!.public
    });
  }
}