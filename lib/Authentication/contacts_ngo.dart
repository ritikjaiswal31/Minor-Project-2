//this page contains the fetched data from firebase of signed in users
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/nav-drawer.dart';


class ItemListn extends StatelessWidget {
  ItemListn({Key? key}) : super(key: key) {
    _stream1 = user_ngoCollection.snapshots();
  }

  final CollectionReference user_ngoCollection =
      FirebaseFirestore.instance.collection('User-ngo');

  //_reference.get()  ---> returns Future<QuerySnapshot>
  //_reference.snapshots()--> Stream<QuerySnapshot> -- realtime updates
  late Stream<QuerySnapshot> _stream1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFFe8772e),
        title: const Text("Food Forward"),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream1,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items = documents
                .map((e) =>
                    { 'address': e['address'], 'name of organization': e['name of organization']})
                .toList();

            //Display the list
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  //Get the item at this index
                  Map thisItem = items[index];
                  //REturn the widget for the list items
                  return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(1.0),
                        width: 300.0,
                        height: 250.0,
                        child: ListTile(
                          tileColor: Color(0xFFf9f7f8),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                "https://images.pexels.com/photos/213780/pexels-photo-213780.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", // Replace with the URL of your image
                                width: double
                                    .infinity, // Set the width of the image to fill the available space
                                height: 100, // Set the height of the image
                                fit: BoxFit
                                    .fitWidth, // Set the fit property to cover or contain
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Org.Name: ${thisItem['name of organization']}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Location: ${thisItem['address']}'),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                child: Text("Contact Us"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFe8772e),
                                  elevation: 0,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ));
                });
          }

          //Show loader
          return const Center(child: CircularProgressIndicator());
        },
      ), //Display a list // Add a FutureBuilder
    );
  }
}