import 'package:copper_customer/db/DatabaseProviderRecord.dart';

class Record {
  int id;
  int customerId;
  double copperWireSize;
  double length;
  double price;
  double cgstPercentage;
  double gstPercentage;
  double totalPrice;
  String recordDate;
  String createdAt;

  Record(
      {this.id,
      this.customerId,
      this.copperWireSize,
      this.length,
      this.price,
      this.totalPrice,
      this.recordDate,
      this.createdAt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProviderRecord.RECORD_ID: id,
      DatabaseProviderRecord.CUSTOMER_ID: customerId,
      DatabaseProviderRecord.COPPER_WIRE_SIZE: copperWireSize,
      DatabaseProviderRecord.LENGTH: length,
      DatabaseProviderRecord.PRICE: price,
      DatabaseProviderRecord.TOTAL_PRICE: totalPrice,
      DatabaseProviderRecord.RECORD_DATE: recordDate,
      DatabaseProviderRecord.CREATED_AT: createdAt
    };

    if (id != null) {
      map[DatabaseProviderRecord.RECORD_ID] = id;
    }

    return map;
  }

  Record.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProviderRecord.RECORD_ID];
    customerId = map[DatabaseProviderRecord.CUSTOMER_ID];
    copperWireSize = map[DatabaseProviderRecord.COPPER_WIRE_SIZE];
    length = map[DatabaseProviderRecord.LENGTH];
    price = map[DatabaseProviderRecord.PRICE];
    totalPrice = map[DatabaseProviderRecord.TOTAL_PRICE];
    recordDate = map[DatabaseProviderRecord.RECORD_DATE];
    createdAt = map[DatabaseProviderRecord.CREATED_AT];
  }
}
