import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database helper/services.dart';


class WorkEdit extends StatefulWidget {
  final String workHeading;
  final String workDescription;
  final String documentName;

  const WorkEdit({Key? key, required this.workHeading, required this.workDescription, required this.documentName}) : super(key: key);

  @override
  State<WorkEdit> createState() => _WorkEditState();
}

class _WorkEditState extends State<WorkEdit> {
  late TextEditingController _headingController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.workDescription);
    _headingController = TextEditingController(text: widget.workHeading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(39, 14, 56, 0.788235294117647),
        elevation: 5,
        bottomOpacity: 0.5,
        shadowColor: Color.fromRGBO(39, 14, 56, 0.788235294117647 ),
        title: TextFormField(
          controller: _headingController,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold), // Text color
        ),
        leading: IconButton(
          icon: BackButton(),
          color: Colors.white, // Change this to the desired color
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Colors.white10,Colors.black45],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(

            controller: _descriptionController,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () async {
          String editedTitle = _headingController.text.toString();
          String editedDesc = _descriptionController.text.toString();

          if (widget.workHeading != editedTitle) {
            // Retrieve the data from the document
            DocumentSnapshot oldDocument = await FirebaseFirestore.instance
                .collection(nameChk ?? nameLogin)
                .doc(widget.documentName)
                .get();
            Map<String, dynamic>? data = oldDocument.data() as Map<String, dynamic>?;
            if (data != null) {
              // Update the key within the data
              print(data);
              var oldKey = data.keys.firstWhere((k) => data[k] == widget.workDescription, orElse: () => "");

              data.remove(oldKey);
              // dynamic value = data[oldKey];  ====== in case if old data is required =====
              data[editedTitle] = editedDesc;

              final docRef = FirebaseFirestore.instance.collection(nameChk ?? nameLogin).doc(widget.documentName);
              final updates = <String, dynamic>{
                widget.workHeading: FieldValue.delete(),
              };
              docRef.update(updates);
              docRef.set(data);
            }else{
              print("no data");
            }
          } else {
            // Update the document if only the description changed
            await FirebaseFirestore.instance
                .collection(nameLogin ?? nameChk)
                .doc(widget.documentName)
                .update({widget.workHeading: editedDesc});
          }

          Navigator.pop(context); // Close the edit screen
        },
        child: Icon(Icons.save, size: 28,color: Colors.white,),
      ),
    );
  }

  @override
  void dispose() {
    _headingController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
}