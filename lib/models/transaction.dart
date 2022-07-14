import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
class Transaction extends ManagedObject<_Transaction> implements _Transaction {}
class _Transaction {
  @primaryKey
  int? txId;

  String? blockchainIdentitatis;
  @Relate(#transactions)
  User? user;
}