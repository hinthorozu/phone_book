import 'package:flutter/material.dart';
import 'package:phonebook/models/contact.dart';
import 'package:phonebook/screens/contact/contact_add.dart';
import 'package:phonebook/screens/contact/contact_list.dart';

void main() {
  runApp(MaterialApp(
    theme:
        ThemeData(primarySwatch: Colors.lightBlue, backgroundColor: Colors.white),
    initialRoute: "/",
    routes: {
      "/": (context) => ContactList(),
      "/contactadd": (context) => ContactAdd(
            contactParam: Contact(),
          )
    },
  ));
}

