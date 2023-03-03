import 'package:a_2/data/db_helper.dart';
import 'package:a_2/screens/main_activity.dart';
import 'package:flutter/material.dart';

class ProfileActivity extends StatefulWidget {
  final int pId;
  const ProfileActivity({super.key, required this.pId});

  @override
  State<ProfileActivity> createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  List<Map<String, dynamic>> _profile = [];
  List<Map<String, dynamic>> _accessLog = [];

  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await DbHelper.createAccess(widget.pId, 'Closed');

        // show
        if (context.mounted) Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile Activity"),
          actions: [
            IconButton(
                onPressed: () {
                  _deleteProfile();
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 33.0, bottom: 10.0),
                child: Text(
                  "\nUSER PROFILE",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Surname: ${_profile[0]['surname']}',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 5.0),
                    Text('Name: ${_profile[0]['name']}',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 5.0),
                    Text('ID: ${_profile[0]['p_id']}',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 5.0),
                    Text('GPA: ${_profile[0]['gpa']}',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 5.0),
                    Text(
                        'Profile created: ${_accessLog[_accessLog.length - 1]['timestamp']}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              const Padding(
                padding: EdgeInsets.only(left: 33.0, bottom: 7.0),
                child: Text(
                  "\nACCESS HISTORY",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(color: Theme.of(context).primaryColor);
                  },
                  itemCount: _accessLog.length,
                  itemBuilder: ((listContext, index) {
                    return Column(children: [
                      ListTile(
                          title: Text(
                        '${_accessLog[index]['timestamp']} - ${_accessLog[index]['access_type']}',
                        style: const TextStyle(fontSize: 14),
                      )),
                    ]);
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _openProfile();
    _getInfo();
  }

  Future<void> _deleteProfile() async {
    await DbHelper.deleteProfile(widget.pId);
  }

  void _getInfo() async {
    final profile = await DbHelper.getProfile(widget.pId);
    final accessLog = await DbHelper.getLogs(widget.pId);
    setState(() {
      _profile = profile;
      _accessLog = accessLog;
      _loading = false;
    });
  }

  void _openProfile() async {
    await DbHelper.createAccess(widget.pId, 'Opened');
  }
}
