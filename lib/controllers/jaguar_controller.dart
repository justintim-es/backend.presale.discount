// import 'package:conduit/conduit.dart';
// import 'package:jaguar_jwt/jaguar_jwt.dart';
// class JaguarController extends Controller {
//     @override
//     Future<RequestOrResponse> handle(Request request) async {
//       final userQuery = Query<User>(context)..where((u) => u.id).equalTo(request.authorization!.ownerID);
//       final user = await userQuery.fetchOne();
//       if (user!.isConfirmed!) {
//         return request;
//       }
//       return Response.unauthorized(body: "Please confirm your e-mail first");
//     }
// }