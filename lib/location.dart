//transforming this model
//generate model adapter then register model adapter
import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 0)
class Location {
  Location({required this.city_name, required this.city_code});
  @HiveField(0)
  final String city_name;
  @HiveField(1)
  final int city_code;
}
