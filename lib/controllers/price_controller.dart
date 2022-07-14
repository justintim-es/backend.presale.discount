import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
class PriceController extends ResourceController {
  ManagedContext context;
  PriceController(this.context);
  @Operation.post('price')
  Future<Response> setPrice(@Bind.path('price') int price) async {
      final shopQuery = Query<User>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID)
      ..values.acceptedPriceGla = price;
      final shop = await shopQuery.updateOne();
      return Response.ok("");
  }
  @Operation.get()
  Future<Response> accepted() async {
      final shopQuery = Query<User>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
      final shop = await shopQuery.fetchOne();
      return Response.ok({
        "accepted": shop!.acceptedPriceGla
      });
  }
}