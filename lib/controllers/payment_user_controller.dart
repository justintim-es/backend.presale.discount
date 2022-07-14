import 'package:baschack/models/payment_user.dart';
import 'package:conduit/conduit.dart';

class PaymentUserController extends ResourceController {
  ManagedContext context;
  PaymentUserController(this.context);

  @Operation.get('identitatis')
  Future<Response> byId(@Bind.path('identitatis') String identitatis) async {
    final paymentQuery = Query<PaymentUser>(context)..where((x) => x.transaction).equalTo(identitatis);
    final payment = await paymentQuery.fetchOne();
    if (payment == null) {
      return Response.badRequest();
    }
    final confirmations = aw
    //its wrong to depend on the frontend cant we update 
    //saldo opwaarderen
    //we cant do it transfer because it also checks the normal txs we only want to update the paymentQuery if 21 confirmations
    //are over
  }

}