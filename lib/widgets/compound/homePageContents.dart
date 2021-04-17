import '../../screens/showWebView.dart';

import '../../models/advertisement_model.dart';

import '../../utilities/utilities.dart';
import 'package:carousel_slider/carousel_slider.dart';

//import 'quickServices.dart';
import 'package:flutter/material.dart';

class HomePageContent extends StatelessWidget {
  //final BrandPromotion topBrand;
  final List<Advertisement> ads;

  HomePageContent(this.ads);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Top advertisement which covers whole width of the screen
            CarouselSlider(
              items: ads.where((element) => element.displayType!=null && (element.displayType=='Horizontal' || element.displayType.isEmpty)).map((ad) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Utilities.getImage(
                            ad.advertisementImage,
                            height: MediaQuery.of(context).size.width * 0.5,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          print("Clicked....${ad.url}");
                          //Utilities.launchURL(ad.url);
                          Navigator.pushNamed(context, ShowWebView.routeName,
                              arguments: ad.url);
                        },
                        child: null,
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                //height: 400.0,

                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),

            //Hide Quick Serverices until phase 4
            //QuickServices(),

            //Rest of the advertisements
            ...ads.where((element) => element.displayType!=null && element.displayType=='Vertical').map((ad) {
              return Container(
                padding: EdgeInsets.only(top: 10),
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                          image: Utilities.getImage(ad.advertisementImage)),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        print("Clicked....${ad.advertisementName}");
                        //Utilities.launchURL(ad.url);
                        Navigator.pushNamed(context, ShowWebView.routeName,
                            arguments: ad.url);
                      },
                       child: Container(),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
