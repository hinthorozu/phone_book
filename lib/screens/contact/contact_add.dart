import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:phonebook/db/db_helper.dart';
import 'package:phonebook/mixins/validation_mixin.dart';
import 'package:phonebook/models/index.dart';

class ContactAdd extends StatefulWidget {
  final contactParam;
  const ContactAdd({Key key, @required this.contactParam}) : super(key: key);
  @override
  ContactAddState createState() => ContactAddState();
}

class ContactAddState extends State<ContactAdd> with ValidationMixin {
  final formKey = GlobalKey<
      FormState>(); // birden fazla form var ise submit butonu hangi formla ilgilenecek?
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var contact = new Contact();
  DbHelper _dbHelper;
  var maskTextInputFormatterPhone = MaskTextInputFormatter(
      mask: "+## (###) ###-##-##", filter: {"#": RegExp(r'[0-9]')});
  @override
  void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contact = widget.contactParam as Contact;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            contact.id == null ? "Yeni Kişi Ekle" : contact.name + " Düzenle"),
      ),
      body: Column(
        children: [
          Stack(children: [
            contact.avatar == null
                ? Image.asset(
                    "assets/img/person.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  )
                : Image.file(
                    File(contact.avatar),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
            Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  onPressed: getFile,
                  icon: Icon(Icons.camera_alt),
                  color: Colors.white,
                ))
          ]),
          Padding(
            padding: EdgeInsets.all(8),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: nameField()),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: phoneField()),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: submitButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) contact.avatar = image.path;
    });
  }

  Widget nameField() {
    return TextFormField(
      // labelText: bildiğimiz label, hintText: Place holder
      decoration: InputDecoration(labelText: "Kişi Adı"),
      initialValue: contact.name,
      validator: validateTwoChracterWithSpace,
      onSaved: (String value) {
        contact.name = value;
      },
    );
  }

  Widget phoneField() {
    return TextFormField(
      inputFormatters: [maskTextInputFormatterPhone],
      decoration: InputDecoration(
          labelText: "Telefon Numarası", hintText: "+90 (555) 555-55-55"),
      initialValue: contact.phoneNumber,
      keyboardType: TextInputType.phone,
      onSaved: (String value) {
        contact.phoneNumber = value;
      },
    );
  }

  void saveContact(Contact contact) async {
    if (contact.id == null) {
      await _dbHelper.contactAdd(contact);
    } else {
      await _dbHelper.contactUpdate(contact);
    }
  }

  Widget submitButton() {
    return RaisedButton(
      child: Text("Kaydet"),
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context).textTheme.button.color,
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(contact.phoneNumber);
          saveContact(contact);
          setState(() {});
          _scaffoldKey.currentState
              .showSnackBar(
                  SnackBar(content: Text("${contact.name} Kaydedildi.")))
              .closed
              .then((value) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          });
        }
      },
    );
  }
}
