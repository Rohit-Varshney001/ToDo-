import 'package:flutter/material.dart';

import 'database helper/services.dart';
import 'database helper/show_data.dart';

class CompleteDocument extends StatefulWidget {
  final String heading;

  const CompleteDocument({Key? key, required this.heading}) : super(key: key);

  @override
  State<CompleteDocument> createState() => _CompleteDocumentState();
}

class _CompleteDocumentState extends State<CompleteDocument> {
  TextEditingController workNameController = TextEditingController();
  TextEditingController workDescController = TextEditingController();
  bool _isLoading = false; // Add a boolean variable to track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.heading), // Accessing the heading passed to the widget
      ),
      body: ShowData(
        heading: widget.heading,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: workNameController,
                            decoration: InputDecoration(
                              labelText: 'Work Name',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: workDescController,
                            decoration: InputDecoration(
                              labelText: 'Work Desc',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _isLoading // Show loading indicator if _isLoading is true
                            ? CircularProgressIndicator()
                            : Container(
                                height: 45,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Colors.deepPurpleAccent
                                    ],
                                  ),
                                ),
                                child: TextButton(
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _isLoading =
                                                true; // Set loading state to true
                                          });
                                          DatabaseMethods.addWork(
                                            widget.heading,
                                            workNameController.text.toString(),
                                            workDescController.text.toString(),
                                          ).then((value) {
                                            setState(() {
                                              _isLoading = false;
                                              workNameController.clear();
                                              workDescController.clear();
                                            });
                                            Navigator.pop(context);
                                          });
                                        },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
