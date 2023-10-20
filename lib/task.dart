// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String detail;

  @HiveField(2)
  DateTime time;

  @HiveField(3)
  bool done;

  Task(
      {required this.title,
      required this.detail,
      required this.time,
      required this.done});
}
