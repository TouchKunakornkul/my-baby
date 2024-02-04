import 'package:drift/drift.dart';
import 'package:my_baby/configs/database.dart';
import 'package:my_baby/models/stock_model.dart';

part 'stock_dao.g.dart';

@DriftAccessor(tables: [Stocks])
class StocksDao extends DatabaseAccessor<AppDatabase> with _$StocksDaoMixin {
  final AppDatabase db;
  StocksDao(this.db) : super(db);

  Future<List<Stock>> listStock(int childId) {
    return (select(db.stocks)
          ..where((g) => g.childId.equals(childId))
          ..orderBy([
            (g) =>
                OrderingTerm(expression: g.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<void> createStock(StocksCompanion stock) {
    return into(db.stocks).insert(stock);
  }

  Future<void> updateStock(Stock stock) {
    return update(db.stocks).replace(stock);
  }

  Future<void> deleteStock(Stock stock) {
    return delete(db.stocks).delete(stock);
  }
}
