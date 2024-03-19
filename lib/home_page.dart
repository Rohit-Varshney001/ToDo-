import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:todo_app/add_work.dart';
import 'package:todo_app/database%20helper/check_user.dart';
import 'package:todo_app/inside_grid.dart';
import 'package:todo_app/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Stream? collectionData;
  var nameChk = username;
  var nameLogin = name;
  TextEditingController categoryEditController = TextEditingController();
  List quotesList = [
    {"id": 1, "quote": "\"Success is not final, Failure is not fatal; it is the courage to continue that counts\""},
    {"id": 2, "quote": "\"If you set your goals ridiculously high and it's a failure, you will fail above everyone else's success.\""},
    {"id": 3, "quote": "\"Darkness cannot drive out darkness: only light can do that. Hate cannot drive out hate: only love can do that.\""},
  ];
  CarouselController carouselController = CarouselController();
  int current_index = 0;

  var arrColours  = [
    LinearGradient(
      colors: [Colors.orange, Colors.orangeAccent.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.green, Colors.teal.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.amber, Colors.yellow.shade200],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.green, Colors.lightGreen.shade200],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.grey, Colors.blueGrey.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.orangeAccent, Colors.deepOrange.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.yellow, Colors.orange.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.green, Colors.teal.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.grey, Colors.blueGrey.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.black, Colors.grey.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.red, Colors.redAccent.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.yellow, Colors.amber.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Colors.black54, Colors.grey.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
  Stream<QuerySnapshot>? futureSnapshot;


  Widget buildDocumentText(BuildContext context, int index, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    final List<DocumentSnapshot> documents = snapshot.data!.docs;
    final String documentName = documents[index].id;
    return Text(
      documentName,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureSnapshot = FirebaseFirestore.instance.collection(nameLogin ?? nameChk).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            toolbarHeight: 50,
            pinned: true,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.deepPurpleAccent,
            expandedHeight: 400.0,
            flexibleSpace: FlexibleSpaceBar(

              title:Text(

                "Hii, ${user_name_login ?? user_name_chk}",

        

                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                ),),
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [


                      Text("Hii, ${user_name_login ?? user_name_chk}", style: TextStyle(

         

                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Colors.white
                      )),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: GestureDetector(
                          onTap: (){
                            showDialog(
                              barrierDismissible: false, // Prevent dismissing the dialog when tapped outside
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm LogOut'),
                                  content: Text('Are you sure you want to Log out your account?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Show a loading indicator
                                        showDialog(
                                          barrierDismissible: false, // Prevent dismissing the dialog when tapped outside
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              title: Text('Logging Out...'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(), // Circular loading indicator
                                                  SizedBox(height: 10),
                                                  Text('Please wait...'), // Optional message
                                                ],
                                              ),
                                            );
                                          },
                                        );

                                        // Get the reference to the Firestore document
                                        FirebaseAuth.instance.signOut().then((value) {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder:
                                              (context) => LoginPage()));
                                        });


                                        // Update the document to delete the specified field

                                        Navigator.of(context).pop(); // Close the dialog
                                        Navigator.of(context).pop(); // Close the confirmation dialog
                                      },

                                      child: Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ClipOval(
                            child:  Image.asset("assets/images/profile_logo.png"),
                            clipBehavior: Clip.hardEdge,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      color: Colors.deepPurpleAccent,
                      child: Stack(

                        children: [



                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2), // Set the color and opacity of circles
                              ),
                              margin: EdgeInsets.only(
                                left: 0, // Adjust the left margin of circles
                                top: 80, // Adjust the top margin of circles
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2), // Set the color and opacity of circles
                              ),
                              margin: EdgeInsets.only(
                                left: 180, // Adjust the left margin of circles
                                top: 20, // Adjust the top margin of circles
                              ),
                            ),
                          ),

                          CarouselSlider(items: quotesList.map((item) => Padding(
                            padding: const EdgeInsets.only(top: 25.0,left: 10),
                            child: Text(
                              item["quote"],style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),
                            ),
                          )).toList(),
                              options: CarouselOptions(
                                  scrollPhysics: BouncingScrollPhysics(),
                                  autoPlay: true,
                                  aspectRatio: 1.5,
                                  autoPlayInterval: Duration(seconds: 3),
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
                                children: quotesList.asMap().entries.map((entry) {

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
                                              ? Colors.deepPurple.shade200
                                              : Colors.purple.shade50),
                                    ),
                                  );
                                }).toList(),
                              ))


                        ],
                      ),
                    ),
                  ),
                ],
              ),

            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: futureSnapshot,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                      child: Container(
                        width: 0,
                        height: 0,
                      )
                  );
                }
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 210,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final String documentName = documents[index].id;
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteDocument(heading: documentName)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: arrColours[index % arrColours.length],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    documentName,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),

                                ),
                              ),
                              PopupMenuButton(
                                icon: Icon(Icons.more_vert,
                                  color: Colors.white,),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.edit,color: Colors.deepPurpleAccent,),
                                        title: Text('Edit',style: TextStyle(color: Colors.deepPurpleAccent),),
                                        onTap: (){
                                          showDialog(
                                            barrierDismissible: false, // Prevent dismissing the dialog when tapped outside
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Edit Category',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
                                                content: TextField(
                                                  controller: categoryEditController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Work Category',
                                                    hintText: documentName,
                                                    border: OutlineInputBorder(),enabledBorder:OutlineInputBorder() ,
                                                    filled: true,
                                                    fillColor: Colors.deepPurple.withOpacity(0.1),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      // Show a loading indicator
                                                      showDialog(
                                                        barrierDismissible: false, // Prevent dismissing the dialog when tapped outside
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Updating...'),
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                CircularProgressIndicator(), // Circular loading indicator
                                                                SizedBox(height: 10),
                                                                Text('Please wait...'), // Optional message
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      // Get the reference to the Firestore document
                                                      final oldDocRef = FirebaseFirestore.instance.collection(nameChk ?? nameLogin).doc(documentName);
                                                      final oldDocSnapshot = await oldDocRef.get();

                                                      // Create a new document with the desired ID
                                                      final newDocRef = FirebaseFirestore.instance.collection(nameChk ?? nameLogin).doc(categoryEditController.text.toString());

                                                      // Copy data from old document to new document
                                                      await newDocRef.set(oldDocSnapshot.data()!);

                                                      // Delete the old document if necessary
                                                      await oldDocRef.delete();

                                                      // Close the dialogs
                                                      Navigator.of(context).pop(); // Close the "Updating" dialog
                                                      Navigator.of(context).pop(); // Close the confirmation dialog
                                                    },
                                                    child: Text('Update'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: Icon(Icons.delete,color: Colors.deepPurpleAccent,),
                                        title: Text('Delete',style: TextStyle(color: Colors.deepPurpleAccent),),
                                        onTap: (){
                                          showDialog(
                                            barrierDismissible: false, // Prevent dismissing the dialog when tapped outside
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Delete'),
                                                content: Text('Are you sure you want to delete this item?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      // Show a loading indicator
                                                      showDialog(
                                                        barrierDismissible: false, // Prevent dismissing the dialog when tapped outside
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Deleting...'),
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                CircularProgressIndicator(), // Circular loading indicator
                                                                SizedBox(height: 10),
                                                                Text('Please wait...'), // Optional message
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      // Get the reference to the Firestore document
                                                      await FirebaseFirestore.instance.collection(nameChk ?? nameLogin).doc(documentName).delete();

                                                      // Update the document to delete the specified fiel
                                                      Navigator.of(context).pop(); // Close the dialog
                                                      Navigator.of(context).pop(); // Close the confirmation dialog
                                                    },

                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ];
                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                    childCount: documents.length,
                  ),
                );
              },
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          AddWorkPopup(context);

        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

}