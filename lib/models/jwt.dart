
import 'package:baschack/baschack.dart';

class JWT extends ManagedObject<_JWT> implements _JWT {}
class _JWT {
  @Column(primaryKey: true)
  String? used;
}