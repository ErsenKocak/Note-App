import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatelessWidget {
  String _image;
  CarouselSliderWidget({
    Key? key,
    required String image,
  })  : _image = image,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
            autoPlayInterval: Duration(seconds: 3),
            autoPlay: true,
            enableInfiniteScroll: false,
            scrollPhysics: BouncingScrollPhysics(),
            aspectRatio: 16 / 9
            // enlargeCenterPage: true,
            ),
        items: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              children: <Widget>[
                Image.file(
                  File(_image),
                  fit: BoxFit.fill,
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: SizedBox()),
                ),
              ],
            ),
          ),
        ]);
  }
}
