// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lab101/update_user.dart';
import 'package:lab101/db_helper.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Map<String, dynamic>> us = [];

  final dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users "),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                //            dbHelper.onDrop();
                await Navigator.pushNamed(context, '/adduser');
                _query();
              }),
          IconButton(
              icon: Icon(Icons.countertops),
              onPressed: () {
                _count();
              })
        ],
      ),
      body: _myListView(context),
    );
  }

  void _count() async {
    final countrow = await dbHelper.queryRowCount();
    print('Row count = $countrow');
  }

  Future<void> _query() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      us = allRows;
    });
  }

  void _delete(Map<String, dynamic> us) async {
    var _id = us['_id'];
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(_id);
    final rowscount = await dbHelper.queryRowCount();
    print('deleted $rowsDeleted row(s): row $_id');
    if (rowscount == 0) {
      print('Empty table');
    }
    _query();
  }

  Widget _myListView(BuildContext context) {
    // _query();
    if (us.isEmpty) {
      return Center(child: Text("Empty Table"));
    } else {
      return ListView.builder(
        itemCount: us.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('No: ' +
                us[index]['_id'].toString() +
                ' ' +
                'Name: ' +
                us[index]['name'] +
                ' Age: ' +
                us[index]['age'].toString()),
            subtitle: Text('Salary: ' +
                us[index]['salary'].toString() +
                ' Mobile: ' +
                us[index]['mobile']),
            trailing: IconButton(
                icon: const Icon(Icons.delete_rounded),
                onPressed: () {
                  _delete(us[index]);
                }),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserPage(
                      us: us[index],
                    ),
                  ));
              _query();
            },
          );
        },
      );
    }
  }
}
