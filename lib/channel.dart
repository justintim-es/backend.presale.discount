import 'package:baschack/baschack.dart';
import 'package:baschack/controllers/accepted_controller.dart';
import 'package:baschack/controllers/balance_controller.dart';
import 'package:baschack/controllers/buy_controller.dart';
import 'package:baschack/controllers/card_price_controller.dart';
import 'package:baschack/controllers/card_purchase_controller.dart';
import 'package:baschack/controllers/cards_controller.dart';
import 'package:baschack/controllers/cards_subdomain_controller.dart';
import 'package:baschack/controllers/confirm_controller.dart';
import 'package:baschack/controllers/double_password_controller.dart';
import 'package:baschack/controllers/is_confirmed_controller.dart';
import 'package:baschack/controllers/price_controller.dart';
import 'package:baschack/controllers/public_controller.dart';
import 'package:baschack/controllers/redeems_controller.dart';
import 'package:baschack/controllers/register_reseller_controller.dart';
import 'package:baschack/controllers/register_shop_controller.dart';
import 'package:baschack/controllers/register_shopper_controller.dart';
import 'package:baschack/controllers/reseller_activate_controller.dart';
import 'package:baschack/controllers/reseller_controller.dart';
import 'package:baschack/controllers/transfer_controller.dart';
import 'package:baschack/controllers/user_controller.dart';
import 'package:baschack/models/config.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:conduit/managed_auth.dart';
import 'package:mailer/smtp_server.dart';
import 'package:baschack/models/jwt.dart';
import 'package:baschack/controllers/redeem_controller.dart';
/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class BaschackChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  ManagedContext? context;
  AuthServer? authServer;
  Config? config;
  SmtpServer? smtp;
  @override
  Future prepare() async {
    CORSPolicy.defaultPolicy.allowedRequestHeaders.addAll(["x-username", "x-first-password", "x-second-password"]);
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    config = Config(options!.configurationFilePath!);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final store = PostgreSQLPersistentStore.fromConnectionInfo(
      config!.database!.username, 
      config!.database!.password!, 
      config!.database!.host, 
      config!.database!.port, 
      config!.database!.dbName);
    context = ManagedContext(dataModel, store);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
    smtp = gmail(config!.smtp!.username!, config!.smtp!.password!);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://conduit.io/docs/http/request_controller/
    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });
    router.route('/register-shop/:reseller').link(() => RegisterShopController(context!, authServer!, config!, smtp!));
    router.route('/register-shopper').link(() => RegisterShopperController(context!, config!, smtp!, authServer!)); 
    router.route('/register-reseller').link(() => RegisterResellerController(context!, authServer!, config!, smtp!));
    router.route('/confirm/:confirmation').link(() => ConfirmController(context!));
    router.route('/card-price/:cardId/:subdomain').link(() => CardPriceController(context!));
    router.route('/auth/token').link(() => DoublePasswordController(context!))!.link(() => AuthController(authServer!));
    router.route('/user').
    link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => UserController(context!));
    router.route('/cards')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => CardsController(context!));
    router.route('/cards-subdomain/:subdomain')
    .link(() => CardsSubdomainController(context!));
    router.route('/accepted/:subdomain')
    .link(() => AcceptedController(context!));
    router.route('/price/[:price]')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => PriceController(context!));
    router.route('/buy/:cardId/:subdomain')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => BuyController(context!, config!));
    router.route('/public')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => PublicController(context!));

    router.route('/transfer')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => TransferController(context!, config!));

    router.route('/balance/[:card]')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => BalanceController(context!, config!));

    router.route('/card-purchase/[:cardId[/:subdomain]]')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => CardPurchaseController(context!));

	router.route('/redeem/[:jwt[/:amount]]')
    .link(() => Authorizer.bearer(authServer!))
    !.link(() => IsConfirmedController(context!))
    !.link(() => RedeemController(context!));

  router.route('/redeems/:card')
  .link(() => Authorizer.bearer(authServer!))
  !.link(() => IsConfirmedController(context!))
  !.link(() => RedeemsController(context!));

  router.route('/reseller')
  .link(() => Authorizer.bearer(authServer!))
  !.link(() => IsConfirmedController(context!))
  !.link(() => ResellerController(context!));

  router.route('/reseller-activate')
  .link(() => Authorizer.bearer(authServer!))
  !.link(() => IsConfirmedController(context!))
  !.link(() => ResellerActivateController(context!, config!));
    return router;
  }
}
