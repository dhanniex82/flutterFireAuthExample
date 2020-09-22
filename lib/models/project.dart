import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String id;
  String projectCode;
  String description;
  String material;
  String unit; //ton or m3
  num quantity;
  num delivered;
  int numOfDelivery; //truck, trailer etc
  Map<String, DateTime> deliverySchedule; //start date -> due date
  Map<String, dynamic> address; //address line, city, post code
  DocumentReference reference;

  Project(
      {this.projectCode,
      this.description,
      this.material,
      this.unit,
      this.quantity,
      this.address,
      this.deliverySchedule})
      : id = null,
        delivered = 0,
        numOfDelivery = 0,
        reference = null;

  Project.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        reference = snapshot.reference,
        projectCode = snapshot.data()['projectCode'],
        description = snapshot.data()['description'],
        material = snapshot.data()['material'],
        unit = snapshot.data()['unit'],
        quantity = snapshot.data()['quantity'] as num,
        address = snapshot.data()['address'] as Map<String, dynamic>,
        deliverySchedule =
            (snapshot.data()['deliverySchedule'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, e == null ? null : e.toDate()),
        ),
        delivered = snapshot.data()['delivered'] as num,
        numOfDelivery = (snapshot.data()['numOfDelivery'] as num)?.toInt();

  Map<String, dynamic> toMap() {
    return {
      'projectCode': projectCode,
      'description': description,
      'material': material,
      'unit': unit,
      'quantity': quantity,
      'delivered': delivered ?? 0,
      'numOfDelivery': numOfDelivery ?? 0,
      'address': address?.map((key, value) => MapEntry(key, value ?? '')),
      'deliverySchedule':
          deliverySchedule?.map((k, e) => MapEntry(k, e ?? DateTime.now())),
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'projectCode': projectCode,
      'description': description,
      'material': material,
      'unit': unit,
      'quantity': quantity,
      'address': address?.map((key, value) => MapEntry(key, value ?? '')),
      'deliverySchedule':
          deliverySchedule?.map((k, e) => MapEntry(k, e ?? DateTime.now())),
    };
  }
}
