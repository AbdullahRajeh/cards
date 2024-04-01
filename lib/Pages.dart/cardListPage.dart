import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addCardPage.dart';

class CardListPage extends StatefulWidget {
  final String groupId;

  const CardListPage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  String groupName = '';
  Color groupBackgroundColor = Colors.white;
  Color groupTextColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _getGroupDetails(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: groupBackgroundColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: groupBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  color: groupTextColor,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.007,
                  ),
                  child: Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: groupTextColor,
                      fontFamily: 'TajawalLight',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cards')
                  .where('groupId', isEqualTo: widget.groupId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final cards = snapshot.data!.docs;

                return Container(
                  color: groupBackgroundColor,
                  child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return _buildCardList(context, card);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: groupTextColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: AddCardPage(groupId: widget.groupId),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: groupBackgroundColor,
        ),
      ),
    );
  }

  Widget _buildCardList(BuildContext context, DocumentSnapshot card) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.01,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.015,
        bottom: MediaQuery.of(context).size.height * 0.02,
        left: MediaQuery.of(context).size.width * 0.015,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            card['word'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: groupTextColor,
              fontFamily: 'TajawalLight',
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Future<void> _getGroupDetails(String groupId) async {
    try {
      DocumentSnapshot groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      setState(() {
        groupName = groupDoc['name'];
        groupBackgroundColor =
            Color(int.parse(groupDoc['Background_Color'], radix: 16));
        groupTextColor = Color(int.parse(groupDoc['Text_Color'], radix: 16));
      });
    } catch (e) {
      print('Error getting group details: $e');
    }
  }
}
