import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel{
  String? userkey;
  late String phoneNumber;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? refs;

  UserModel({
    required this.phoneNumber,
    required this.address,
    required this.geoFirePoint,
    required this.createdDate,
    this.refs,});

  UserModel.fromJson(Map<String, dynamic> json, this.userkey, this.refs) {
    userkey = json['userkey'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];

    geoFirePoint =GeoFirePoint((json['geoFirePoint']['geopoint']).latitude, (json['geoFirePoint']['geopoint']).longitude);
    createdDate = (json['refs']==null)? DateTime.now().toUtc()
        :(json['createdDate'] as Timestamp).toDate();
    refs = json['refs'];
  }
UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;

    map['geoFirePoint'] = geoFirePoint.data;
    map['createdDate'] = createdDate;
    return map;
  }

}