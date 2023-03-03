// modal

import 'package:flutter/material.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _surname = TextEditingController();
    TextEditingController _name = TextEditingController();
    TextEditingController _id = TextEditingController();
    TextEditingController _gpa = TextEditingController();

    return Container(
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _surname,
              decoration: InputDecoration(label: Text('Surname')),
            )
          ],
        ));
  }
}
