import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';

class ConfirmController extends ResourceController {
  ManagedContext context;
  ConfirmController(this.context);

  @Operation.post('confirmation')
  Future<Response> confirm(@Bind.path('confirmation') String confirmation) async {
    final updateQuery = Query<User>(context)
      ..values.isConfirmed = true
      ..where((x) => x.confirmation).equalTo(confirmation);
    final updated = await updateQuery.updateOne();
    return Response.ok("");
  }
}