import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String groupId;
  const CardList({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cards')
          .where('groupId', isEqualTo: groupId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final cards = snapshot.data!.docs;

        if (cards.isEmpty) {
          return Center(child: Text('No cards found for this group'));
        }

        return ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return ListTile(
              title: Text(card['word']),
              subtitle: Text(card['definition']),
            );
          },
        );
      },
    );
  }
}
