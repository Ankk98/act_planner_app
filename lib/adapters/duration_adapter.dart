import 'package:hive/hive.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 11; // Choose a unique ID

  @override
  Duration read(BinaryReader reader) {
    final micros = reader.readInt();
    return Duration(microseconds: micros);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMicroseconds);
  }
}
