import 'package:hive/hive.dart';
import 'asset.dart';

part 'act.g.dart';

@HiveType(typeId: 3)
class Act {
  @HiveField(0) String id;
  @HiveField(1) String eventId;
  @HiveField(2) String name;
  @HiveField(3) String description;
  @HiveField(4) DateTime startTime;
  @HiveField(5) Duration duration;
  @HiveField(6) int sequenceId;
  @HiveField(7) bool isApproved;
  @HiveField(8) List<String> participantIds;
  @HiveField(9) List<Asset> assets;
  @HiveField(10) String createdBy;

  Act({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
    required this.startTime,
    required this.duration,
    required this.sequenceId,
    required this.isApproved,
    required this.participantIds,
    required this.assets,
    required this.createdBy,
  });
}