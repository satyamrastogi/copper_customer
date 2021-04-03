
import 'package:copper_customer/db/DatabaseProviderCustomer.dart';

class Customer{
  int id;
  String name;
  String phoneNumber;
  String address;
  String gstNumber;
  String createdAt;


  @override
  String toString() {
    return 'Customer{id: $id, name: $name, phoneNumber: $phoneNumber, address: $address, gstNumber: $gstNumber, createdAt: $createdAt}';
  }

  Customer({
    this.id,
    this.name,
    this.phoneNumber,
    this.address,
    this.gstNumber,
    this.createdAt
  });


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.NAME: name,
      DatabaseProvider.PHONE_NUMBER: phoneNumber,
      DatabaseProvider.GST_NO: gstNumber,
      DatabaseProvider.CREATED_AT: createdAt,
      DatabaseProvider.ADDRESS: address
    };

    if (id != null) {
      map[DatabaseProvider.CUSTOMER_ID] = id;
    }

    return map;
  }

  Customer.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.CUSTOMER_ID];
    name = map[DatabaseProvider.NAME];
    phoneNumber = map[DatabaseProvider.PHONE_NUMBER].toString();
    gstNumber = map[DatabaseProvider.GST_NO].toString();
    address = map[DatabaseProvider.ADDRESS];
    createdAt = map[DatabaseProvider.CREATED_AT];
  }
}