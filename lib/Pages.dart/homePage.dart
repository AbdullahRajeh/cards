import 'dart:ui';

import 'package:cards/Pages.dart/addCardPage.dart';
import 'package:cards/Pages.dart/cardListPage.dart';
import 'package:cards/Pages.dart/cardsPage.dart';
import 'package:cards/Pages.dart/groupList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//F5F7F8
//F4CE14
//495E57
//45474B

class _HomePageState extends State<HomePage> {
  late FirebaseFirestore _firestore;
  late TextEditingController groupNameController;
  late TextEditingController groupDescriptionController;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    groupNameController = TextEditingController();
    groupDescriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), // Disable bouncing behavior
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('groups')
                      .where('userId', isEqualTo: widget.user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final groups = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return _buildGroupCard(
                          context,
                          group,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return _showBottomSheet(
                context,
                groupNameController,
                groupDescriptionController,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, DocumentSnapshot group) {
    Color bgColor = Color(int.parse(group['Background_Color'], radix: 16));
    Color textColor = Color(int.parse(group['Text_Color'], radix: 16));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardListPage(
              groupId: group.id,
            ),
          ),
        );
      },
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
                    group['name'],
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TajawalLight',
                        fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (group['description'] != null &&
                      group['description'] != '')
                    Text(
                      group['description'],
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'TajawalLight',
                        fontSize: 15,
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

  Widget _showBottomSheet(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController descriptionController,
  ) {
    Color selectedBGColor = Colors.white;
    Color selectedTextColor = Colors.blue;
    bool _isCustomizing = false;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        "مجموعة جديدة",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontFamily: "TajawalLight",
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),

                    //========================={NAME FIELD}=========================
                    Column(
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
                                focusColor: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                    //========================={NAME FIELD}=========================

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.018,
                    ),
                    //========================={DESCRIPTION FIELD}=========================
                    Column(
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
                            controller: groupNameController,
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
                                focusColor: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                    //========================={DESCRIPTION FIELD}=========================
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      "تخصيص المجموعة",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "TajawalLight",
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),

                    // Color picker for background color
                    Row(
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
                                      pickerColor: selectedBGColor,
                                      onColorChanged: (Color color) {
                                        setState(() {
                                          selectedBGColor = color;
                                        });
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
                              color: selectedBGColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            "لون الخلفية",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: "TajawalLight",
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),

                    Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),

                    // Color picker for text color
                    Row(
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
                                      pickerColor: selectedTextColor,
                                      onColorChanged: (Color color) {
                                        setState(() {
                                          selectedTextColor = color;
                                        });
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
                              color: selectedTextColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: Text(
                            "لون النص",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: "TajawalLight",
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),

                    Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          _addGroup(
                            nameController.text,
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
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addGroup(String groupName, String groupDescription,
      Color bgColor, Color textColor, BuildContext context) async {
    try {
      print(
          'Adding group: $groupName, $groupDescription, ${bgColor.value.toRadixString(16)}, ${textColor.value.toRadixString(16)}');
      await _firestore.collection('groups').add({
        'name': groupName,
        'description': groupDescription,
        'userId': widget.user.uid,
        'Background_Color': bgColor.value.toRadixString(16),
        'Text_Color': textColor.value.toRadixString(16),
      });
      setState(() {
        groupNameController.clear();
        groupDescriptionController.clear();
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error adding group: $e');
    }
  }
}
