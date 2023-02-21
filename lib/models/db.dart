import 'package:hive/hive.dart';

part 'db.g.dart';

@HiveType(typeId: 0)
class DataBase extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late bool check; // false -> not strikethrough

  @HiveField(2)
  late bool edited; // true -> it is being edited

  @HiveField(3)
  late int level; //1, 2, 3 -> easy, medium, hard

  @HiveField(4)
  late int year; //2021 format

  @HiveField(5)
  late int month; //05 format

  @HiveField(6)
  late int date; //05 format

  DataBase({
    required this.title,
    required this.check,
    required this.edited,
    required this.level,
  });
}
