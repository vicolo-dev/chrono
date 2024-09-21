import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:clock_app/common/utils/id.dart';

// enum AlarmEventType{
//   schedule,
//   cancel,
// }

class AlarmEvent extends ListItem {
  late  int id;
  // late  final AlarmEventType type;
  late  DateTime eventTime;
  late  ScheduledNotificationType notificationType;
  late  String description;
  late  int scheduleId;
  late  DateTime startDate;
  late bool isActive;

  AlarmEvent({
    // required this.type,
    required this.eventTime,
    required this.notificationType,
    required this.description,
    required this.scheduleId,
    required this.startDate,
    required this.isActive,
  }) : id = getId();

  AlarmEvent.fromJson(Json json) {
    if (json == null) {
      id = 0;
      // type = AlarmEventType.schedule;
      eventTime = DateTime.now();
      notificationType = ScheduledNotificationType.alarm;
      description = '';
      scheduleId = -1;
      startDate = DateTime.now();
      isActive = false;
      return;
    }
    id = json['id'] ?? 0;
    // type = AlarmEventType.values[json['eventType'] ?? 0];
    eventTime = DateTime.fromMillisecondsSinceEpoch(json['eventTime'] ?? 0);
    notificationType =
        ScheduledNotificationType.values[json['notificationType'] ?? 0];
    description = json['description'] ?? '';
    scheduleId = json['scheduleId'] ?? 0;
    startDate = DateTime.fromMillisecondsSinceEpoch(json['startDate'] ?? 0);
    isActive = json['isActive'] ?? false;
  }

  @override
  Json? toJson() => {
        'id': id,
        'scheduleId': scheduleId,
        'eventTime': eventTime.millisecondsSinceEpoch,
        'startDate': startDate.millisecondsSinceEpoch,
// 'eventType': type.index,
        'notificationType': notificationType.index,
        'description': description,
        'isActive': isActive,
      };

  @override
  copy() {
    return AlarmEvent(
      // type: type,
      eventTime: eventTime,
      notificationType: notificationType,
      description: description,
      scheduleId: scheduleId,
      startDate: startDate,
      isActive: isActive,
    );
  }

  @override
  bool get isDeletable => false;

  @override
  void copyFrom(other) {
    id = other.id;
    // type = other.type;
    eventTime = other.eventTime;
    notificationType = other.notificationType;
    description = other.description;
    scheduleId = other.scheduleId;
    startDate = other.startDate;
    isActive = other.isActive;
      

  }
}
