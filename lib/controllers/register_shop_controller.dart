import 'package:baschack/models/config.dart';
import 'package:conduit/conduit.dart';
import 'package:baschack/models/shop_register.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:random_string/random_string.dart';
import 'package:baschack/models/user.dart';
import 'package:dio/dio.dart' as d;
import 'package:dbcrypt/dbcrypt.dart';

class RegisterShopController extends ResourceController {
  ManagedContext context;
  AuthServer authServer;
  Config config;
  SmtpServer smtp;
  RegisterShopController(this.context, this.authServer, this.config, this.smtp);

  @Operation.post()
  Future<Response> register(@Bind.body() ShopRegister shopRegister) async {
    final salt = await AuthUtility.generateRandomSalt();
    final confirmation = randomAlphaNumeric(256);
    final keypair = await d.Dio().get('${config.gladiatorsurl}/rationem');
    final userQuery = Query<User>(context)
      ..values.uschus = Uschus.shop
      ..values.salt = salt
      ..values.city = shopRegister.city
      ..values.company = shopRegister.company
      ..values.username = shopRegister.email
      ..values.confirmation = confirmation
      ..values.public = keypair.data['privatusClavis'].toString()
      ..values.private = keypair.data['publicaClavis'].toString()
      ..values.subdomain = shopRegister.subdomain
      ..values.isConfirmed = false
      ..values.jaguarSecret = randomAlphaNumeric(16)
      ..values.firstPassword = DBCrypt().hashpw(shopRegister.firstPassword!, DBCrypt().gensalt())
      ..values.secondPassword = DBCrypt().hashpw(shopRegister.secondPassword!, DBCrypt().gensalt())
      ..values.hashedPassword = authServer.hashPassword('${shopRegister.firstPassword}:${shopRegister.secondPassword}', salt);
    final msg = Message()
      ..from = Address(config.smtp!.username!, 'Presale.discount')
      ..recipients.add(shopRegister.email)
      ..subject = 'Please confirm your e-mail'    
      ..text = 'Please confirm your e-mail by pressing on the following link\n${config.frontend}/confirm-fetch/$confirmation';
    await send(msg, smtp);
    final user = await userQuery.insert();
    return Response.ok("");
  }

}