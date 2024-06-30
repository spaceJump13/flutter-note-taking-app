import 'package:hive/hive.dart';

part 'pin.g.dart';

@HiveType(typeId: 1)
class Pin extends HiveObject {
  @HiveField(0)
  late String pin;

  Pin(this.pin);
}
