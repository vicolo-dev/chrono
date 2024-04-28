import 'package:clock_app/common/types/json.dart';

class ScheduleId extends JsonSerializable {
  late int id;

  ScheduleId({
    required this.id,
  });

  ScheduleId.fromJson(Json? json) {
    if (json == null) {
      id = -1;
      return;
    }
    id = json['id'] ?? -1;
  }

  @override
  Json toJson() => {
        'id': id,
      };
}
