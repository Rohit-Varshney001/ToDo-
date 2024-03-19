import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/work_edit.dart';

import '../login_page.dart';
import '../uiHelper/dotted_line.dart';
import 'check_user.dart';

class ShowData extends StatefulWidget {
  final String heading;

  const ShowData({Key? key, required this.heading}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  var nameChk = username;
  var nameLogin = name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection(nameChk ?? nameLogin).doc(widget.heading).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text("No Data Found"));
          }

          // Access the data from the snapshot
          final Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null || data.isEmpty) {
            return const Center(child: Text("No Data Found"));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                mainAxisExtent: 250,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                // Access the key and value pair for each item
                final entry = data.entries.elementAt(index);
                final String workName = entry.key;
                final String workDescription = entry.value.toString();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkEdit(workHeading: workName, workDescription: workDescription, documentName: widget.heading,)));
                  },
                  onLongPress: () {
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
                                final docRef = await FirebaseFirestore.instance.collection(nameChk ?? nameLogin).doc(widget.heading);
                                final Map<String, dynamic> updates = {
                                  workName: FieldValue.delete(),
                                };

                                // Update the document to delete the specified field
                                await docRef.update(updates);

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


                  child: Card(
                    color: Colors.deepPurpleAccent,
                    shadowColor: Colors.black,

                    elevation: 5,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  workName,
                                  overflow:TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Colors.white
                                  ),
                                ),

                              ),

                              Container(
                                height: 1,
                                margin: EdgeInsets.only(bottom: 10.0,top: 10), // Adjust margin as needed
                                child: CustomPaint(
                                  size: Size(400, 1), // Adjust size as needed
                                  painter: DottedLinePainter(), // Custom painter for dotted line
                                ),
                              ),
                              Flexible(

                                child: Text(
                                  workDescription,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(

                                      fontSize: 16,

                                      color: Colors.white

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2), // Set the color and opacity of circles
                            ),
                            margin: EdgeInsets.only(
                              right: 50, // Adjust the left margin of circles
                              top: 100, // Adjust the top margin of circles
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
                              left: 100, // Adjust the left margin of circles
                              top: 40, // Adjust the top margin of circles
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}