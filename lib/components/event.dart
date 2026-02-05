import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../faculty/faculty_event_show.dart';

Widget Event(final bool isStudent, {bool grid = false, String? clubId}) {
  Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection("Events").orderBy("Date");
  if (clubId != null && clubId.isNotEmpty) {
    query = query.where('ClubId', isEqualTo: clubId);
  }

  return StreamBuilder(
      stream: query.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          if (grid) {
            return GridView.builder(
                itemCount: docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.95),
                itemBuilder: (context, i) => _eventCard(context, docs[i], isStudent));
          }
          return ListView.builder(itemCount: docs.length, itemBuilder: (context, i) => _eventCard(context, docs[i], isStudent));
        }
        return const Center(child: CircularProgressIndicator());
      });
}

Widget _eventCard(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> x, bool isStudent) {
  final card = Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.white,
    child: InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowEvent(x: x))),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: (x.data()['urlEvent'] ?? '').toString().isNotEmpty
                      ? Image.network(x['urlEvent'], width: double.infinity, fit: BoxFit.cover)
                      : Image.asset("assets/images/events.gif", width: double.infinity, fit: BoxFit.cover))),
          const SizedBox(height: 8),
          Text(x['Title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: "Bold", fontSize: 22)),
          Text(x['Date'].toString().substring(0, 10), style: const TextStyle(fontSize: 13)),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () async {
                  final lat = x.data()['Lat'];
                  final lng = x.data()['Lng'];
                  if (lat != null && lng != null) {
                    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.map_outlined)),
          )
        ]),
      ),
    ),
  );

  if (isStudent) return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: card);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Slidable(
      key: ValueKey(x.id),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(60),
            onPressed: (v) async => FirebaseFirestore.instance.collection("Events").doc(x.id).delete(),
            spacing: 2,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFFE4A49),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: card,
    ),
  );
}
