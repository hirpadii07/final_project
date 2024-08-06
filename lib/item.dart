// item.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'items')
class Item {
  @primaryKey
  final int id;
  final String name;

  Item(this.id, this.name);
}
