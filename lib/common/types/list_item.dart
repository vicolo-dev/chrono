import 'package:clock_app/common/utils/json_serialize.dart';

abstract class ListItem extends JsonSerializable {
  int get id;
  bool isDeletable = true;
}
