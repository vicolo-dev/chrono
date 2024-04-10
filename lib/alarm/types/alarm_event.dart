import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/types/notification_type.dart';
import 'package:flutter/foundation.dart';

// enum AlarmEventType{
//   schedule,
//   cancel,
// }

class AlarmEvent extends ListItem {
  late  final int id;
  // late  final AlarmEventType type;
  late  final DateTime eventTime;
  late  final ScheduledNotificationType notificationType;
  late  final String description;
  late  final int scheduleId;
  late  final DateTime startDate;
  late bool isActive;

  AlarmEvent({
    // required this.type,
    required this.eventTime,
    required this.notificationType,
    required this.description,
    required this.scheduleId,
    required this.startDate,
    required this.isActive,
  }):id=UniqueKey().hashCode;


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
    notificationType = ScheduledNotificationType.values[json['notificationType'] ?? 0];
    description = json['description'] ?? '';
    scheduleId = json['scheduleId'] ?? 0;
    startDate = DateTime.fromMillisecondsSinceEpoch(json['startDate'] ?? 0);
    isActive = json['isActive'] ?? false;
      

  }



  @override
  Json? toJson()  =>{
    'id': id,
    'scheduleId': scheduleId,
  'eventTime': eventTime.millisecondsSinceEpoch,
'startDate': startDate.millisecondsSinceEpoch,
// 'eventType': type.index,
'notificationType': notificationType.index,
'description':description,
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

  }
