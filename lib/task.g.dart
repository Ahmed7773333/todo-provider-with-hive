// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    return Task(
      title: reader.read(),
      detail: reader.read(),
      time: reader.read(),
      done: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..write(obj.title)
      ..write(obj.detail)
      ..write(obj.time)
      ..write(obj.done);
  }
}
