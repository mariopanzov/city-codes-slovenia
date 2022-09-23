import 'package:hive/hive.dart';
import 'location.dart';

class Boxes {
  static Box<Location> getLocations() => Hive.box('locations');
}
