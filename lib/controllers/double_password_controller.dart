import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:dbcrypt/dbcrypt.dart';
class DoublePasswordController extends Controller {
  final ManagedContext context;
  DoublePasswordController(this.context);

  @override
 Future<RequestOrResponse> handle(Request request) async {
    final userQuery = Query<User>(context)..where((u) => u.username).equalTo(request.raw.headers.value('x-username')!);
    final user = await userQuery.fetchOne();
    if (DBCrypt().checkpw(request.raw.headers.value('x-first-password')!, user!.firstPassword!)) {
      if (user.lock != null) {
        if (user.lock!.isAfter(DateTime.now())) {
          if (DBCrypt().checkpw(request.raw.headers.value('x-second-password')!, user.secondPassword!)) {
            return request;
          } else {
            final timelockUserQuery = Query<User>(context)..where((i) => i.id).equalTo(user.id)..values.lock = DateTime.now().add(const Duration(hours: 1));
            await timelockUserQuery.updateOne();
          }
        }   
      } else {
        if (DBCrypt().checkpw(request.raw.headers.value('x-second-password')!, user.secondPassword!)) {
            return request;
          } else {
            final timelockUserQuery = Query<User>(context)..where((i) => i.id).equalTo(user.id)..values.lock = DateTime.now().add(const Duration(hours: 1));
            await timelockUserQuery.updateOne();
          }
      }
    } 
    return Response.badRequest(body: {
      "error": "invalid credentials or account is still locked for one hour"
    });
  }
}