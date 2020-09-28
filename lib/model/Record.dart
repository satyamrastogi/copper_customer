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

  Record(
      {this.id,
      this.customerId,
      this.copperWireSize,
      this.length,
      this.price,
      this.cgstPercentage,
      this.gstPercentage,
      this.totalPrice});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProviderRecord.RECORD_ID: id,
      DatabaseProviderRecord.CUSTOMER_ID: customerId,
      DatabaseProviderRecord.COPPER_WIRE_SIZE: copperWireSize,
      DatabaseProviderRecord.LENGTH: length,
      DatabaseProviderRecord.PRICE: price,
      DatabaseProviderRecord.CGST_PERCENTAGE: cgstPercentage,
      DatabaseProviderRecord.GST_PERCENTAGE: gstPercentage,
      DatabaseProviderRecord.TOTAL_PRICE: totalPrice
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
    cgstPercentage = map[DatabaseProviderRecord.CGST_PERCENTAGE];
    gstPercentage = map[DatabaseProviderRecord.GST_PERCENTAGE];
    totalPrice = map[DatabaseProviderRecord.TOTAL_PRICE];
  }
}
