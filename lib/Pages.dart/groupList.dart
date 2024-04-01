// import 'package:cards/Pages.dart/cardListPage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class GroupList extends StatefulWidget {
//   final User user;
//   final FirebaseFirestore firestore;
//   const GroupList({Key? key, required this.user, required this.firestore})
//       : super(key: key);

//   @override
//   _GroupListState createState() => _GroupListState();
// }

// class _GroupListState extends State<GroupList> {
//   late bool showOptions;

//   @override
//   void initState() {
//     super.initState();
//     showOptions = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: widget.firestore
//           .collection('groups')
//           .where('userId', isEqualTo: widget.user.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         final groups =
//             snapshot.data!.docs.reversed.toList(); // Reverse the list of groups

//         return ListView.builder(
//           itemCount: groups.length,
//           itemBuilder: (context, index) {
//             final group = groups[index];
//             return _buildGroupCard(context, group);
//           },
//         );
//       },
//     );
//   }


// }
