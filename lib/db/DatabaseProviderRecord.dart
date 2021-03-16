import 'package:copper_customer/model/Record.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProviderRecord {
  static const String TABLE_RECORD = "RECORD";
  static const String RECORD_ID = "ID";
  static const String CUSTOMER_ID = "CUSTOMER_ID";
  static const String COPPER_WIRE_SIZE = "COPPER_WIRE_SIZE";
  static const String LENGTH = "LENGTH";
  static const String PRICE = "PRICE";
  static const String TOTAL_PRICE = "TOTAL_PRICE";
  static const String RECORD_DATE = "RECORD_DATE";
  static const String CREATED_AT = "CREATED_AT";

  DatabaseProviderRecord._();

  static final DatabaseProviderRecord db = DatabaseProviderRecord._();
  Database _database;

  Future<Database> get database async {
    print("database getter called for Record");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'recordTest1.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating record table");

        await database.execute(
          "CREATE TABLE $TABLE_RECORD ("
          "$RECORD_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$CUSTOMER_ID INTEGER,"
          "$COPPER_WIRE_SIZE FLOAT,"
          "$LENGTH FLOAT,"
          "$PRICE FLOAT,"
          "$TOTAL_PRICE FLOAT,"
          "$RECORD_DATE String,"
          "$CREATED_AT String"
          ")",
        );
      },
    );
  }

  Future<List<Record>> getRecord(int customerId) async {
    final db = await database;
    var records = await db.rawQuery("SELECT * FROM $TABLE_RECORD where CUSTOMER_ID = $customerId order by $RECORD_DATE desc");

    List<Record> result = List<Record>();

    records.forEach((currentRecord) {
      Record record = Record.fromMap(currentRecord);

      result.add(record);
    });

    return result;
  }

  Future<Record> insert(Record record) async {
    final db = await database;
    record.id = await db.insert(TABLE_RECORD, record.toMap());
    return record;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_RECORD,
      where: "id = ?",
      whereArgs: [id],
    );
  }
  Future<int> deleteWithCustomerId(int id) async {
    final db = await database;

    var result = await db.delete(
      TABLE_RECORD,
      where: "customer_id = ?",
      whereArgs: [id],
    );
    return result;
  }

  Future<int> update(Record record) async {
    final db = await database;

    return await db.update(
      TABLE_RECORD,
      record.toMap(),
      where: "id = ?",
      whereArgs: [record.id],
    );
  }
}
