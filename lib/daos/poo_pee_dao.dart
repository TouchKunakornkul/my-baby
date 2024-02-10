import 'package:drift/drift.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/models/poo_pee_model.dart';

part 'poo_pee_dao.g.dart';

@DriftAccessor(tables: [PooPees])
class PooPeesDao extends DatabaseAccessor<AppDatabase> with _$PooPeesDaoMixin {
  final AppDatabase db;
  PooPeesDao(this.db) : super(db);

  Future<List<PooPee>> listPooPee(int childId) {
    return (select(db.pooPees)
          ..where((g) => g.childId.equals(childId))
          ..orderBy([
            (g) =>
                OrderingTerm(expression: g.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<void> createPooPee(PooPeesCompanion pooPee) {
    return into(db.pooPees).insert(pooPee);
  }

  Future<void> updatePooPee(PooPee pooPee) {
    return update(db.pooPees).replace(pooPee);
  }

  Future<void> deletePooPee(PooPee pooPee) {
    return delete(db.pooPees).delete(pooPee);
  }
}
