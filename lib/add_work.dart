import 'package:flutter/material.dart';
import 'database helper/services.dart';

void AddWorkPopup(BuildContext context) {
  TextEditingController categoryController = TextEditingController();
  TextEditingController workNameController = TextEditingController();
  TextEditingController workDescController = TextEditingController();
  bool _isLoading = false; // Add a boolean variable to track loading state

  showModalBottomSheet(
    isScrollControlled: true, // Ensure the bottom sheet takes the full height
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // Use StatefulBuilder to update the state of the modal bottom sheet
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: 320,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: categoryController,
                        decoration: InputDecoration(
                          labelText: 'Work Category',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ),
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
                            colors: [Colors.purple, Colors.deepPurpleAccent],
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
                            _isLoading = true; // Set loading state to true
                          });
                          DatabaseMethods.addWork(
                            categoryController.text.toString(),
                            workNameController.text.toString(),
                            workDescController.text.toString(),
                          ).then((value) {
                            setState(() {
                              _isLoading = false; // Set loading state to false after operation completes
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
  );
}
