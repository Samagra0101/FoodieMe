import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:foodie/main.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Foodie',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MyHome(),
    );
  }
}
var bannerItems=["Chole Bhature","Pav Bhaji","Aloo Paratha","Chole Kulche"];
var bannerImage=["assets/images/cholebhature.png","assets/images/pavbhaji.png","assets/images/alooparatha.png","assets/images/cholekulche.png"];

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height; //screenHeight=height of device's screen
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    Future<List<Widget>> createList() async {
       List<Widget> items=[];
       String dataString=await DefaultAssetBundle.of(context).loadString("assets/restuarants.json");
       List<dynamic> dataJson=jsonDecode(dataString);

       dataJson.forEach((object) {
         String finalString="";
         List<dynamic> dataList=object["placeItems"];
         dataList.forEach((item) {
           finalString=finalString+item+" | ";
         });
         items.add(Padding(padding: EdgeInsets.all(2.0),
         child: Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(10.0)),
             boxShadow: [
               BoxShadow(
                 color: Colors.black26,
                 spreadRadius: 2.0,
                 blurRadius: 5.0,
               )
             ]
           ),
           margin: EdgeInsets.all(5.0),
           child: Row(
             mainAxisSize: MainAxisSize.max,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               ClipRRect(
                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
                 child: Image.asset(object["placeImage"],width: 80,height: 80,fit: BoxFit.cover,),
                                ),
               SizedBox(
                 width: 250,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(object["placeName"]),
                       Text(finalString,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12.0,color: Colors.black54),maxLines: 1),
                       //Text("Min Order: ₹{object["minOrder"]}",style: TextStyle(fontSize: 12.0,color: Colors.black54),)

                     ],
                   ),
                 ),
               )
             ],
           ),
         ),));
       });
       return items;
    }
    return Scaffold(
      body: Container(
          height: screenHeight,
          width: screenWidth,
          child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      child: Row(       //to create custom appbar
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
                          Text("FoodieMe",style: TextStyle(fontSize: 50,fontFamily: "samantha",fontWeight: FontWeight.bold),),
                          IconButton(onPressed: (){}, icon: Icon(Icons.person))
                        ],
                      ),
                    ),
                    BannerWidgetArea(),
                    Container(
                      child: FutureBuilder(
                        initialData: <Widget>[Text("")],
                        future: createList(),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return Padding(padding: EdgeInsets.all(8.0),
                            child: ListView(
                              primary: false,
                              shrinkWrap: true,
                              children: snapshot.data!
                            ),);
                          }else{
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    ),
                  ],

                ),
              ))
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){},
        backgroundColor: Colors.black,
      child: Icon(Icons.food_bank),),
    );
  }
}

class BannerWidgetArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height; //screenHeight=height of device's screen
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    PageController controller = PageController(initialPage: 1);
    List<Widget> banners=[];
    for (int i = 0; i < bannerItems.length; i++) {
      var bannerView=Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [Container(     //for shadow effect
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),      //for shadow effect
              ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20.0)),//curved edges of banner images
                  child: Image.asset(bannerImage[i],fit: BoxFit.cover)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent,Colors.black])
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bannerItems[i], style: TextStyle(fontSize: 25.0,color: Colors.white),),
                    Text("More than 50% Off",style: TextStyle(fontSize: 12.0,color: Colors.white),)
                  ],
                ),
              )
            ],
          ),
        ),
      );
      banners.add(bannerView);
    }

    return Container(
      height: screenHeight * 9 / 16,
      width: screenWidth,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: banners,

      ),
    );
  }
}