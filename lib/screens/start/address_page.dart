import 'package:flutter/material.dart';
import 'package:flutter_practice1/screens/start/address_service.dart';
import 'package:flutter_practice1/utils/logger.dart';
import 'package:location/location.dart';
import '../../data/address_model.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  AddressModel? _addressModel;

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onFieldSubmitted: (text)async{
                _addressModel = await AddressService().searchAddressByStr(text);
                setState((){});
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 25,),
                // prefixIconConstraints: BoxConstraints(),
                hintText: "주소를 입력하세요",
                hintStyle: TextStyle(color:Theme.of(context).hintColor),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.navigation, color: Colors.white, size: 18,),
                onPressed: () async {
                Location location = new Location();

                bool _serviceEnabled;
                PermissionStatus _permissionGranted;
                LocationData _locationData;

                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (!_serviceEnabled) {
                    return;
                  }
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) {
                    return;
                  }
                }

                _locationData = await location.getLocation();

                if(_locationData.longitude!=null && _locationData.latitude!=null){
                  AddressService().findAddressByCoordinate(_locationData.longitude!, _locationData.latitude!);
                }

                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                label: Text("현재위치로 찾기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: (_addressModel==null || _addressModel!.result==null || _addressModel!.result!.items==null)?0:_addressModel!.result!.items!.length,
                  itemBuilder: (context, index){
                  if(_addressModel==null || _addressModel!.result==null || _addressModel!.result!.items==null || _addressModel!.result!.items![index].address==null){
                    return Container();
                  }
                    return ListTile(
                      title: Text(_addressModel!.result!.items![index].address!.road??""),
                      subtitle: Text(_addressModel!.result!.items![index].address!.parcel??""),

                    );
                  }
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
