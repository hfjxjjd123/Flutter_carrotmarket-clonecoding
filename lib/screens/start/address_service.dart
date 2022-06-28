import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/consts/keys.dart';
import 'package:flutter_practice1/data/address_model.dart';
import 'package:flutter_practice1/data/address_model2.dart';

import '../../utils/logger.dart';

class AddressService{
  Future<AddressModel> searchAddressByStr(String text) async{

    final formData = {
      'key':VWORLD_KEY,
      'request':'search',
      'query':text,
      'type':'ADDRESS',
      'category':'ROAD',

    };

    final response = await Dio().get("http://api.vworld.kr/req/search", queryParameters: formData)
        .catchError((e){logger.e(e.message);});


    AddressModel addressModel = AddressModel.fromJson(response.data["response"]);
    return addressModel;
  }

  Future<List<AddressModel2>> findAddressByCoordinate(double log, double lat) async {

    final List<Map<String, dynamic>> formDatas = [];

    formDatas.add({
      'key':VWORLD_KEY,
      'service':'address',
      'type':'PARCEL',
      'request':'GetAddress',
      'point':"$log,$lat"
    });
    formDatas.add({
      'key':VWORLD_KEY,
      'service':'address',
      'type':'PARCEL',
      'request':'GetAddress',
      'point':"${log+0.01},$lat"
    });
    formDatas.add({
      'key':VWORLD_KEY,
      'service':'address',
      'type':'PARCEL',
      'request':'GetAddress',
      'point':"${log-0.01},$lat"
    });
    formDatas.add({
      'key':VWORLD_KEY,
      'service':'address',
      'type':'PARCEL',
      'request':'GetAddress',
      'point':"$log,${lat+0.01}"
    });
    formDatas.add({
      'key':VWORLD_KEY,
      'service':'address',
      'type':'PARCEL',
      'request':'GetAddress',
      'point':"$log,${log-0.01}"
    });

    final Map<String, dynamic> formData={
      'key':VWORLD_KEY,
      'service':'address',
      'type':'PARCEL',
      'request':'GetAddress',
      'point':"$log,$lat"
    };

    List<AddressModel2> addresses = [];
    for(Map<String, dynamic> formData in formDatas){
      final response = await Dio().get("http://api.vworld.kr/req/address", queryParameters: formData)
          .catchError((e){logger.e(e.message);});
      logger.d(response);

      if(response.data['response']['status'] == "OK") {
        AddressModel2 addressModel2 = AddressModel2.fromJson(
            response.data["response"]);
        addresses.add(addressModel2);
      }

    }
    logger.d(addresses);
    return addresses;
  }


}

