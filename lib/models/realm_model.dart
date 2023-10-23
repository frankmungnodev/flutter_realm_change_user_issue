import 'package:realm/realm.dart';

part 'realm_model.g.dart';

@RealmModel()
class _Todo {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String title;
  late bool completed;

  late String userId;

  late DateTime createdAt;
  late DateTime updatedAt;
}
