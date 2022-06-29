import 'package:flutter/material.dart';
import 'package:flutter_practice1/screens/start/address_service.dart';
import 'package:flutter_practice1/utils/logger.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/address_model.dart';
import '../../data/address_model2.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  AddressModel? _addressModel;
  bool _isGettingLocation = false;
  TextEditingController _textEditingController = TextEditingController();
  List<AddressModel2> _addressModel2List = [];

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
                _addressModel2List.clear();
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

                onPressed: () async {
                  _addressModel = null;
                  _addressModel2List.clear();
                  setState((){
                    _isGettingLocation = true;
                  });

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
                  List<AddressModel2> addresses = await AddressService().findAddressByCoordinate(_locationData.longitude!, _locationData.latitude!);
                  _addressModel2List.addAll(addresses);
                  setState((){
                    _isGettingLocation = false;
                  });

                }

                },
                icon: (_isGettingLocation)?Icon(Icons.blur_circular):Icon(Icons.navigation, color: Colors.white, size: 18,),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                label: Text((_isGettingLocation)?"위치 가져오는 중":"현재위치로 찾기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
            ),
            if(_addressModel != null)
              Expanded(
               child: ListView.builder(
                 itemCount: (_addressModel==null || _addressModel!.result==null || _addressModel!.result!.items==null)?0:_addressModel!.result!.items!.length,
                   itemBuilder: (context, index){
                   if(_addressModel==null || _addressModel!.result==null || _addressModel!.result!.items==null || _addressModel!.result!.items![index].address==null){
                      return Container();
                   }
                     return ListTile(
                       onTap: (){
                         _saveAddressOnSharedPreference(_addressModel!.result!.items![index].address!.road??"");
                         context.read<PageController>()
                             .animateToPage(2, duration: Duration(milliseconds: 450), curve: Curves.ease);
                       },
                        title: Text(_addressModel!.result!.items![index].address!.road??""),
                        subtitle: Text(_addressModel!.result!.items![index].address!.parcel??""),

                     );
                    }
                  ),
            ),
            if(_addressModel2List.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    itemCount: _addressModel2List.length,
                    itemBuilder: (context, index){
                      if(_addressModel2List[index].result == null || _addressModel2List[index].result!.isEmpty){
                        return Container();
                      }
                      return ListTile(
                        onTap: (){
                          _saveAddressOnSharedPreference(_addressModel2List[index].result![0].text??"");
                          context.read<PageController>()
                              .animateToPage(2, duration: Duration(milliseconds: 450), curve: Curves.ease);
                        },
                        title: Text(_addressModel2List[index].result![0].text??""),
                        subtitle: Text(_addressModel2List[index].result![0].zipcode??""),

                      );
                    }
                ),
              ),
          ],
        ),
      ),
    );
  }
  _saveAddressOnSharedPreference(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', address);
  }

}
