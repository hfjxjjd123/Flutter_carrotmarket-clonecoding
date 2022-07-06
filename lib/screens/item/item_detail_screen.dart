import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice1/consts/consts.dart';
import 'package:flutter_practice1/data/items_model.dart';
import 'package:flutter_practice1/data/user_model.dart';
import 'package:flutter_practice1/repo/item_service.dart';
import 'package:flutter_practice1/screens/item/similar_item.dart';
import 'package:flutter_practice1/states/user_provider.dart';
import 'package:flutter_practice1/utils/logger.dart';
import 'package:flutter_practice1/utils/time_calculation.dart';
import 'package:flutter_practice1/widgets/upload_screen/dividor.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ItemDetailScreen extends StatefulWidget {
  String itemKey;

  ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  bool _isAppbarCollapse =false;
  Size? _size;
  num? _statusBarHeigth;
  num? priceOf;

  @override
  void ininState(){
    _scrollController.addListener(() { //리스너가 일을 안한다...;
      if(_size == null || _statusBarHeigth ==null){
        return;
      }
      if(_isAppbarCollapse){
        if(_scrollController.offset < ( _size!.width - kToolbarHeight - _statusBarHeigth!) ){
          _isAppbarCollapse = false;
          logger.d("changed!");
          setState((){});
        }
      } else{
        if(_scrollController.offset > ( _size!.width - kToolbarHeight - _statusBarHeigth!) ){
          _isAppbarCollapse = true;
          logger.d("changed!");
          setState((){});
        }
      }
    }
    );
    super.initState();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.itemKey = widget.itemKey.replaceFirst(':', '');
    logger.d(widget.itemKey);
    return FutureBuilder<ItemsModel>(
      future: ItemService().getItemModel(widget.itemKey),
      builder: (context, snapshot) {
        logger.d(snapshot.data);
        if(snapshot.hasData){
          UserModel userModel = context.read<UserProvider>().userModel!;
          ItemsModel itemsModel = snapshot.data!;
          priceOf = itemsModel.price;
          return LayoutBuilder(
            builder: (context, constraints){
              _size = MediaQuery.of(context).size;
              _statusBarHeigth = MediaQuery.of(context).padding.top;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Scaffold(
                    body: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        _imagesAppBar(itemsModel),
                        SliverList(
                            delegate:
                            SliverChildListDelegate(
                              [
                                _userSection(userModel),
                                Divider(
                                  thickness: 1,
                                  indent: default_padding,
                                  endIndent: default_padding,
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(default_padding),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(itemsModel.title,
                                        style: Theme.of(context).
                                        textTheme.subtitle1
                                        !.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                                      ),
                                      Container(height: 2*small_padding,),
                                      Text("${itemsModel.category} ' ${TimeCalculation.getTimeDiff(itemsModel.createdDate)}", style: Theme.of(context).textTheme.subtitle2,),
                                      Container(height: 2*small_padding,),
                                      Text(itemsModel.detail,
                                        style: TextStyle(color: Colors.black87, fontSize: 14),
                                      ),
                                      Container(height: 2*small_padding,),
                                      Text("조회 33", style: Theme.of(context).textTheme.subtitle2,),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  indent: default_padding,
                                  endIndent: default_padding,
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: default_padding),
                                  child: TextButton(
                                    onPressed: (){},
                                    child: Text(
                                      "이 게시글 신고하기",
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(vertical: default_padding),
                                      primary: Colors.black26,

                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  indent: default_padding,
                                  endIndent: default_padding,
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                                Padding(
                                    padding: EdgeInsets.all(default_padding),
                                  child: Row(
                                    children: [
                                      Text("학림님의 판매 상품"),
                                      Expanded(child: Container()),
                                      TextButton(
                                        onPressed: (){},
                                        child: Text('더보기', style: TextStyle(color: Colors.black45, fontSize: 12),),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          primary: Colors.grey,
                                        ) ,
                                      ),

                                    ],
                                  ),
                                ),
                              ]
                            ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: default_padding),
                          sliver: SliverGrid.count(
                            crossAxisSpacing: default_padding,
                            crossAxisCount: 2,
                            childAspectRatio: 5/6,
                            children: List.generate(10, (index) => SimilarItem()),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: _buttomSection(),
                  ),
                  Positioned(
                    left: 0, right: 0, top: 0, height: kToolbarHeight+ _statusBarHeigth!,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: (_isAppbarCollapse)?Colors.white:Colors.black12,
                        foregroundColor: (_isAppbarCollapse)?Colors.black87:Colors.white,
                      ),

                    ),
                  )
                ],
              );
            },
          );
        }
        return Container();
      },
    );
  }
  Widget _userSection(UserModel userModel){
    return Padding(
      padding: const EdgeInsets.all(default_padding),
      child: Row(
        children: [
          ExtendedImage.network(
            "https://picsum.photos/50",
            fit: BoxFit.cover,
            width: 50, height: 50,
            shape: BoxShape.circle,
          ),
          Container(width: small_padding,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userModel.phoneNumber.substring(9), style: Theme.of(context).textTheme.subtitle1,),
              Container(height: 8,),
              Text(userModel.address, style: Theme.of(context).textTheme.subtitle2,),
            ],
          ),
          Expanded(child: Container(),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: _size!.width * 0.15,
                        child: Text(
                          "37.3°C",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _size!.width * 0.15, height: _size!.width * 0.02,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2) ,
                          child: LinearProgressIndicator(
                            value: 0.373,
                            color: Colors.blueAccent,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.sentiment_satisfied,
                    size: _size!.width*0.08,
                    color: Colors.blueAccent,
                  ),
                ],),
              Container(height: 2,),
              Text("매너온도",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 10,
                    decoration: TextDecoration.underline
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttomSection(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all( color: Colors.black12, width: 1),
      ),
       height: _size!.width*0.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: small_padding/2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {  },
              icon: Icon(
                Icons.favorite_border,
                size: _size!.width * 0.09,
                color: Colors.grey,
              ),
            ),
            VerticalDivider(
              color: Colors.grey,
              indent: default_padding, endIndent: default_padding,
              thickness: 1,
              width: 2*small_padding+1,
            ),
            Container(width: small_padding,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(priceOf.toString()+"원", style: Theme.of(context).textTheme.subtitle1,),
                Container(height: small_padding,),
                Text('가격제안불가',style: Theme.of(context).textTheme.subtitle2,),
              ],
            ),
            Expanded(child: Container()),
            TextButton(
                onPressed: (){},
                child: Text('채팅으로 거래하기', style: TextStyle(fontSize: 13),),
              style: TextButton.styleFrom(
                  fixedSize: Size(_size!.width * 0.4, _size!.width * 0.2 - 2*small_padding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _imagesAppBar(ItemsModel itemsModel){
    return SliverAppBar(
      expandedHeight: _size!.width,
      flexibleSpace: FlexibleSpaceBar(
        title: SizedBox(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: itemsModel.imageDownloadUrls.length,
            effect: WormEffect(
                activeDotColor: Colors.white,
                dotColor:Colors.white24,
                radius:3,
                dotHeight: 6, dotWidth: 6
            ),
            onDotClicked: ((index){}),
          ),
        ),
        centerTitle: true,
        background: PageView.builder(
          controller: _pageController,
          allowImplicitScrolling: true,
          itemBuilder: (context, index){
            return ExtendedImage.network(
              itemsModel.imageDownloadUrls[index],
              fit: BoxFit.cover,
              scale: 0.1,
            );
          },
          itemCount: itemsModel.imageDownloadUrls.length,
        ),
      ),
    );
  }
}



