import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ItemsModel{
  late String itemKey;
  late String userkey;
  late List<String> imageDownloadUrls;
  late String title;
  late String category;
  late num price;
  late bool negotiable;
  late String detail;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;

  ItemsModel({
    required this.itemKey,
    required this.userkey,
    required this.imageDownloadUrls,
    required this.title,
    required this.category,
    required this.price,
    required this.negotiable,
    required this.detail,
    required this.address,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,});

  ItemsModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
    itemKey = json['itemKey']??"";
    userkey = json['userkey']??"";
    imageDownloadUrls = json['imageDownloadUrls'] != null ? json['imageDownloadUrls'].cast<String>() : [];
    title = json['title']??"";
    category = json['category']??"none";
    price = json['price']??0;
    negotiable = json['negotiable']??false;
    detail = json['detail']??"";
    address = json['address']??"";
    geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude, (json['geoFirePoint']['geopoint']).longitude);
    createdDate = (json['createdDate']==null)? DateTime.now().toUtc()
        :(json['createdDate'] as Timestamp).toDate();
    reference = json['reference'];
  }

  ItemsModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> snapshot) :this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);
  ItemsModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String,dynamic>> snapshot) :this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  static String generateItemKey(String uid){
    String userkey = uid;
    String timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    return '${userkey}_$timeNow';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['itemKey']=itemKey;
    map['userkey'] = userkey;
    map['imageDownloadUrls'] = imageDownloadUrls;
    map['title'] = title;
    map['category'] = category;
    map['price'] = price;
    map['negotiable'] = negotiable;
    map['detail'] = detail;
    map['address'] = address;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createdDate'] = createdDate;
    return map;
  }
  Map<String, dynamic> toMinJson() {
    final map = <String, dynamic>{};
    map['itemKey']=itemKey;
    map['imageDownloadUrls'] = [imageDownloadUrls[0]];
    map['title'] = title;
    map['price'] = price;
       return map;
  }
}