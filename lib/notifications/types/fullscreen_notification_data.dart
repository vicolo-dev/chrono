import 'package:clock_app/common/types/json.dart';

class FullScreenNotificationData {
  int id;
  final String route;

  FullScreenNotificationData({
    required this.id,
    required this.route,
  });
}

typedef Payload = Json;


