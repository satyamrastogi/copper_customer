import 'package:copper_customer/db/DatabaseProviderRecord.dart';
import 'package:copper_customer/model/Customer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_CUSTOMER = "CUSTOMER";
  static const String CUSTOMER_ID = "ID";
  static const String NAME = "NAME";
  static const String IS_ACTIVE = "IS_ACTIVE";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'customer.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating food table");

        await database.execute(
          "CREATE TABLE $TABLE_CUSTOMER ("
          "$CUSTOMER_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$NAME TEXT,"
          "$IS_ACTIVE BOOL"
          ")",
        );
      },
    );
  }

  Future<List<Customer>> getCustomer() async {
    final db = await database;

    var customers =
        await db.query(TABLE_CUSTOMER, columns: [CUSTOMER_ID, NAME, IS_ACTIVE]);

    List<Customer> result = List<Customer>();

    customers.forEach((currentFood) {
      Customer food = Customer.fromMap(currentFood);

      result.add(food);
    });

    return result;
  }

  Future<Customer> insert(Customer customer) async {
    final db = await database;
    customer.id = await db.insert(TABLE_CUSTOMER, customer.toMap());
    return customer;
  }

  Future<int> delete(int id) async {
    final db = await database;
    DatabaseProviderRecord.db.deleteWithCustomerId(id);
    return await db.delete(
      TABLE_CUSTOMER,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Customer customer) async {
    final db = await database;

    return await db.update(
      TABLE_CUSTOMER,
      customer.toMap(),
      where: "id = ?",
      whereArgs: [customer.id],
    );
  }
}
