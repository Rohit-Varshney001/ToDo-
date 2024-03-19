import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:todo_app/login_page.dart';

class SliderScreenState extends StatefulWidget {
  const SliderScreenState({super.key});

  @override
  State<SliderScreenState> createState() => _SliderScreenStateState();
}

class _SliderScreenStateState extends State<SliderScreenState> {
  List imgList = [
    {"id": 1, "image_path": "assets/images/corousal1.png"},
    {"id": 2, "image_path": "assets/images/corousal2.png"},
    {"id": 3, "image_path": "assets/images/corousal3.png"},
  ];

  CarouselController carouselController = CarouselController();
  int current_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              CarouselSlider(

                  items: imgList
                      .map((item) => Image.asset(
                    item['image_path'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ))
                      .toList(),
                  carouselController: carouselController,

                  options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      aspectRatio: 1,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        setState(() {
                          current_index = index;
                        });
                      })),
              Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.asMap().entries.map((entry) {

                      return GestureDetector(
                        onTap: () =>
                            carouselController.animateToPage(entry.key),
                        child: Container(
                          width: current_index == entry.key ? 17 : 7,
                          height: 7.0,
                          margin: EdgeInsets.symmetric(
                            horizontal: 3.0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: current_index == entry.key
                                  ? Colors.teal
                                  : Colors.indigo),
                        ),
                      );
                    }).toList(),
                  ))
            ],
          ),
          Column(
            children: [
              Text(
                "Maximize your productivity",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 10,),
              Text(
                "Life is short, make your To-Do list count",
                style: TextStyle(fontSize: 20,
                    color: Colors.black54),
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  // width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple[800]!, Colors.deepPurple[300]!],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  // width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white!, Colors.white!],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all( // Adding Border.all to specify border properties
                      color: Colors.deepPurple, // Setting the color of the border to black
                      width: 2, // Setting the width of the border to 2 pixels
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}