import 'package:drift/drift.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/models/feeding_model.dart';

part 'feeding_dao.g.dart';

@DriftAccessor(tables: [Feedings])
class FeedingsDao extends DatabaseAccessor<AppDatabase>
    with _$FeedingsDaoMixin {
  FeedingsDao(AppDatabase db) : super(db);
  Future<List<Feeding>> listFeeding() {
    return select(db.feedings).get();
  }

  Future<List<Feeding>> listFeedingByChildId(int childId) {
    return (select(db.feedings)
          ..where((g) => g.childId.equals(childId))
          ..orderBy([
            (g) => OrderingTerm(expression: g.feedTime, mode: OrderingMode.desc)
          ]))
        .get();
  }

  createFeeding(FeedingsCompanion feeding) {
    return into(db.feedings).insert(feeding);
  }

  updateFeeding(Feeding feeding) {
    return update(db.feedings).replace(feeding);
  }

  Future<void> deleteFeeding(Feeding feeding) {
    return delete(db.feedings).delete(feeding);
  }
}
