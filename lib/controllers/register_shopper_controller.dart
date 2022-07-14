import 'package:baschack/models/config.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:baschack/models/shopper_register.dart';
import 'package:dio/dio.dart' as d;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:random_string/random_string.dart';
import 'package:dbcrypt/dbcrypt.dart';
class RegisterShopperController extends ResourceController {
    ManagedContext context;
    Config config; 
    SmtpServer smtp;
    AuthServer authServer;
    RegisterShopperController(this.context, this.config, this.smtp, this.authServer);

    @Operation.post()
    Future<Response> create(@Bind.body() ShopperRegister shopperRegister) async {
      final confirmation = randomAlphaNumeric(256);
      final salt = AuthUtility.generateRandomSalt();
      final keypair = await d.Dio().get('${config.gladiatorsurl}/rationem');
      final userQuery = Query<User>(context)
        ..values.uschus = Uschus.shopper
        ..values.salt = salt
        ..values.username = shopperRegister.email
        ..values.confirmation = confirmation
        ..values.isConfirmed = false
        ..values.firstPassword = DBCrypt().hashpw(shopperRegister.firstPassword!, DBCrypt().gensalt())
        ..values.secondPassword = DBCrypt().hashpw(shopperRegister.secondPassword!, DBCrypt().gensalt())
        ..values.hashedPassword = authServer.hashPassword('${shopperRegister.firstPassword}:${shopperRegister.secondPassword}', salt)
        ..values.private = keypair.data['privatusClavis'].toString()
        ..values.public = keypair.data['publicaClavis'].toString();
      final user = await userQuery.insert();
      final msg = Message()
        ..from = Address(config.smtp!.username!, 'Presale.discount')
        ..recipients.add(shopperRegister.email)
        ..subject = 'Please confirm your e-mail'    
        ..text = 'Please confirm your e-mail by pressing on the following link\nhttps://${shopperRegister.subdomain}.presale.discount/confirm-fetch/${shopperRegister.cardId}/$confirmation';
      await send(msg, smtp);  
      return Response.ok("");
    } 
}