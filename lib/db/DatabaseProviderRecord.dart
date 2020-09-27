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
  static const String GST_PERCENTAGE = "GST_PERCENTAGE";
  static const String CGST_PERCENTAGE = "CGST_PERCENTAGE";
  static const String TOTAL_PRICE = "TOTAL_PRICE";

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
          "$RECORD_ID INTEGER PRIMARY KEY,"
          "$CUSTOMER_ID INTEGER,"
          "$COPPER_WIRE_SIZE FLOAT,"
          "$LENGTH FLOAT,"
          "$PRICE FLOAT,"
          "$CGST_PERCENTAGE FLOAT,"
          "$GST_PERCENTAGE FLOAT,"
          "$TOTAL_PRICE FLOAT"
          ")",
        );
      },
    );
  }

  Future<List<Record>> getRecord(int customerId) async {
    final db = await database;
    var records = await db.rawQuery("SELECT * FROM $TABLE_RECORD where CUSTOMER_ID = $customerId");

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
