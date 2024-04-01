import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCardPage extends StatefulWidget {
  final String groupId;

  const AddCardPage({Key? key, required this.groupId}) : super(key: key);

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  TextEditingController wordTextController = TextEditingController();
  TextEditingController definitionTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.07,
          right: MediaQuery.of(context).size.width * 0.07,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'إضافة بطاقة جديدة',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'TajawalLight',
                ),
              ),
            ),
            SizedBox(height: 20.0),

            //==================={Word Field}===================
            _buildWordField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            //==================={Word Field}===================
            //==================={Definition Field}===================
            _buildDefinitionField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            //==================={Definition Field}===================
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _addCard();
              },
              child: SizedBox(
                // Wrap the ElevatedButton with SizedBox
                width: double.infinity, // Set width to full width
                child: Center(
                  // Center the text inside the button
                  child: Text(
                    'إضافة بطاقة',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'TajawalLight',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "الكلمة",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontFamily: "TajawalLight",
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextFormField(
            controller: wordTextController,
            decoration: InputDecoration(
              hintText: "المصفوفات..",
              hintTextDirection: TextDirection.rtl,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintStyle: TextStyle(
                fontSize: 15,
                fontFamily: "TajawalLight",
              ),
              focusColor: Colors.black,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget _buildDefinitionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "المعنى",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontFamily: "TajawalLight",
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextFormField(
            controller: definitionTextController,
            decoration: InputDecoration(
              hintText: "قيم متعددة من نفس النوع تحت اسم واحد..",
              hintTextDirection: TextDirection.rtl,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintStyle: TextStyle(
                fontSize: 15,
                fontFamily: "TajawalLight",
              ),
              focusColor: Colors.black,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  void _addCard() {
    String frontText = wordTextController.text.trim();
    String backText = definitionTextController.text.trim();
    if (frontText.isNotEmpty && backText.isNotEmpty) {
      FirebaseFirestore.instance.collection('cards').add({
        'groupId': widget.groupId,
        'definition': frontText,
        'word': backText,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Card added successfully'),
        ));
        Navigator.pop(context);
      }).catchError((error) {
        print('Failed to add card: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add card. Please try again.'),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields'),
      ));
    }
  }

  @override
  void dispose() {
    wordTextController.dispose();
    definitionTextController.dispose();
    super.dispose();
  }
}
