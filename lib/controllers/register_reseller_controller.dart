import 'package:baschack/models/config.dart';
import 'package:baschack/models/reseller_in.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:random_string/random_string.dart';
import 'package:dio/dio.dart' as d;
import 'package:dbcrypt/dbcrypt.dart';

class RegisterResellerController extends ResourceController {
  ManagedContext context;
  AuthServer authServer;
  Config config;
  SmtpServer smtp;
  
  RegisterResellerController(this.context, this.authServer, this.config, this.smtp);

  @Operation.post()
  Future<Response> register(@Bind.body() ResellerIn reseller) async {
    final salt = AuthUtility.generateRandomSalt();
    final confirmation = randomAlphaNumeric(256);
    final keypair = await d.Dio().get('${config.gladiatorsurl}/rationem');
    final userQuery = Query<User>(context)
      ..values.uschus = Uschus.reseller
      ..values.confirmation = confirmation
      ..values.isConfirmed = false
      ..values.salt = salt
      ..values.private = keypair.data['privatusClavis'].toString()
      ..values.public = keypair.data['publicaClavis'].toString()
      ..values.username = reseller.email
      ..values.firstPassword = DBCrypt().hashpw(reseller.firstPassword!, DBCrypt().gensalt())
      ..values.secondPassword = DBCrypt().hashpw(reseller.secondPassword!, DBCrypt().gensalt())
      ..values.hashedPassword = authServer.hashPassword('${reseller.firstPassword}:${reseller.secondPassword}', salt);
    final user = await userQuery.insert();
    final msg = Message()
      ..from = Address(config.smtp!.username!, 'Presale.discount')
      ..recipients.add(reseller.email)
      ..subject = 'Please confirm your e-mail'    
      ..text = 'Please confirm your e-mail by pressing on the following link\n${config.frontend}/confirm-fetch/$confirmation';
    await send(msg, smtp);
    return Response.ok("");
  }
}
