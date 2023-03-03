import 'package:a_2/data/db_helper.dart';
import 'package:a_2/screens/profile_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

// List<String> profileList = {

// }
class _MainActivityState extends State<MainActivity> {
  List<Map<String, dynamic>> _profiles = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _surname = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _gpa = TextEditingController();

  bool _loading = true;
  bool _showId = false;

  @override
  Widget build(BuildContext context) {
    _refreshProfiles();
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Main Activity',
          ),
          actions: [
            IconButton(
              icon: (_showId == true)
                  ? const Icon(Icons.abc)
                  : const Icon(Icons.numbers),
              onPressed: () {
                _showId = !_showId; // invert it
                _refreshProfiles();
              },
            )
          ]),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(color: Theme.of(context).primaryColor);
        },
        itemCount: _profiles.length,
        itemBuilder: ((listContext, index) {
          return ListTile(
              title: (_showId == true)
                  ? Text('${index + 1}. ${_profiles[index]['p_id']}')
                  : Text(
                      '${index + 1}. ${_profiles[index]['surname']}, ${_profiles[index]['name']}'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProfileActivity(
                      pId: int.parse('${_profiles[index]['p_id']}')))));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _profileForm();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white70),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshProfiles();
    print("${_profiles.length} profiles");
  }

  Future<void> _addProfile() async {
    await DbHelper.createProfile(
        int.parse(_id.text), _surname.text, _name.text, _gpa.text);
    await DbHelper.createAccess(int.parse(_id.text), 'Created');
    _refreshProfiles();
  }

  void _profileForm() {
    showModalBottomSheet(
      context: context,
      elevation: 7,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            top: 20.0,
            left: 30,
            right: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 35),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-zA-Z-]+$').hasMatch(value)) {
                      return "Please enter a valid surname.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: _surname,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.green,
                    labelText: "Student Surname",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-zA-Z-]+$').hasMatch(value)) {
                      return "Please enter a valid name.";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: _name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.green,
                    labelText: "Student Name",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.length < 8 ||
                        value.length > 8) {
                      return "Please enter an 8 digits number betwen 10000000\nand 9999999";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: _id,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.green,
                    labelText: "Student ID",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.contains('.')) {
                      var gpaSplit = value.split('.');
                      if (int.parse(gpaSplit[0]) < 0 ||
                          int.parse(gpaSplit[0]) > 4) {
                        return "Please enter a value between 0 and 4.3";
                      }
                      if (int.parse(gpaSplit[0]) == 4 &&
                          (int.parse(gpaSplit[1]) < 0 &&
                              int.parse(gpaSplit[1]) > 3)) {
                        return "Please enter a value between 0 and 4.3";
                      }
                    }
                    if (value.isEmpty) {
                      return "Please enter a value between 0 and 4.3";
                    }
                    return null;
                  },
                  controller: _gpa,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.green,
                    labelText: "Student GPA",
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // clear textfields
                      _surname.text = '';
                      _name.text = '';
                      _gpa.text = '';
                      _id.text = '';
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _addProfile();

                        // clear textfields
                        _surname.text = '';
                        _name.text = '';
                        _gpa.text = '';
                        _id.text = '';
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  void _refreshProfiles() async {
    final List<Map<String, dynamic>> profiles;
    if (_showId == true) {
      profiles = await DbHelper.getProfilesById();
    } else {
      profiles = await DbHelper.getProfilesBySurname();
    }
    setState(() {
      _profiles = profiles;
      _loading = false;
    });
    print("${_profiles.length} profiles");
  }
}
