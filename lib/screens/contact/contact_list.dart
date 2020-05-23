import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phonebook/db/db_helper.dart';
import 'package:phonebook/models/index.dart';
import 'package:phonebook/screens/contact/contact_add.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends StatefulWidget {
  @override
  ContactListState createState() => ContactListState();
}

class ContactListState extends State<ContactList> {
  DbHelper _dbHelper;

  @override
  void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adres Defteri"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContactAdd(contactParam: Contact())));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
        future: _dbHelper.getListContact(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          if (snapshot.data.isEmpty)
            return Center(
              child: Text("Adres Defteri Boş",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            );

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = snapshot.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ContactAdd(
                                  contactParam: contact,
                                )));
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      await _dbHelper.contactDelete(contact.id);
                      setState(() {});

                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("${contact.name} Silindi"),
                        action: SnackBarAction(
                          label: "Geri Al",
                          onPressed: () async {
                            await _dbHelper.contactAdd(contact);

                            setState(() {});
                          },
                        ),
                      ));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: contact.avatar == null
                            ? AssetImage("assets/img/person.jpg")
                            : FileImage(File(contact.avatar)),
                        child: Text(
                          contact.name[0].toUpperCase(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(contact.name),
                      subtitle: Text(contact.phoneNumber),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.red,
                          ),
                          onPressed: () async =>
                              _callContact(contact.phoneNumber)),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  _callContact(String phoneNumber) async {
    String tel = "tel:$phoneNumber";
    if (await canLaunch(tel)) {
      await launch(tel);
    }

  }
}
