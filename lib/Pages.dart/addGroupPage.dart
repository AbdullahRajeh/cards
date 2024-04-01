import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddGroupPage extends StatefulWidget {
  @override
  AddGroupPageState createState() => AddGroupPageState();
}

class AddGroupPageState extends State<AddGroupPage> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Color selectedBGColor = Colors.white;
  Color selectedTextColor = Colors.blue;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildHeader(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: Text(
                    "معاينة",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "TajawalLight",
                    ),
                  ),
                ),
                _buildGroupCard(
                  groupNameController.text,
                  descriptionController.text,
                  selectedBGColor,
                  selectedTextColor,
                  context,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildNameField(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.018,
                ),
                _buildDescriptionField(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildCustomizationHeader(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildColorPickerRow(
                  context,
                  selectedBGColor,
                  "لون الخلفية",
                  (Color color) {
                    setState(() {
                      selectedBGColor = color;
                    });
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildColorPickerRow(
                  context,
                  selectedTextColor,
                  "لون النص",
                  (Color color) {
                    setState(() {
                      selectedTextColor = color;
                    });
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildAddGroupButton(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color randomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
      1.0, // Alpha (opacity)
    );
  }

  Widget _buildGroupCard(String Name, String Description, Color bgColor,
      Color textColor, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * 0.02,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 25,
              color: textColor,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    Name,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TajawalLight',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (Description != null && Description != '')
                    Text(
                      Description,
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'TajawalLight',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        "مجموعة جديدة",
        style: TextStyle(
          fontSize: 30,
          color: Colors.black87,
          fontFamily: "TajawalLight",
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "اسم المجموعة",
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
            controller: groupNameController,
            decoration: InputDecoration(
              hintText: "اسم المجموعة",
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

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "وصف المجموعة",
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
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: "وصف المجموعة",
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

  Widget _buildCustomizationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.color_lens_outlined),
          onPressed: () {
            setState(() {
              selectedBGColor = randomColor();
              selectedTextColor = randomColor();
            });
          },
        ),
        Text(
          "تخصيص المجموعة",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: "TajawalLight",
          ),
        ),
      ],
    );
  }

  Widget _buildColorPickerRow(BuildContext context, Color color, String label,
      ValueChanged<Color> onChanged) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: color,
                      onColorChanged: (Color newColor) {
                        onChanged(newColor);
                      },
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('تم'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontFamily: "TajawalLight",
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget _buildAddGroupButton() {
    return ElevatedButton(
      onPressed: () {
        if (groupNameController.text.isNotEmpty) {
          _addGroup(
            groupNameController.text,
            descriptionController.text,
            selectedBGColor,
            selectedTextColor,
            context,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        shadowColor: Colors.transparent,
        minimumSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.06,
        ),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: TextStyle(
          fontSize: 20,
          fontFamily: "TajawalLight",
          color: Colors.white,
        ),
      ),
      child: Text(
        "إنشاء المجموعة",
        style: TextStyle(
          fontSize: 20,
          fontFamily: "TajawalLight",
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addGroup(String groupName, String groupDescription,
      Color bgColor, Color textColor, BuildContext context) async {
    try {
      print(
          'Adding group: $groupName, $groupDescription, ${bgColor.value.toRadixString(16)}, ${textColor.value.toRadixString(16)}');
      await _firestore.collection('groups').add({
        'name': groupName,
        'description': groupDescription,
        'userId': user.uid,
        'Background_Color': bgColor.value.toRadixString(16),
        'Text_Color': textColor.value.toRadixString(16),
      });
      setState(() {
        groupNameController.clear();
        descriptionController.clear();
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error adding group: $e');
    }
  }
}
