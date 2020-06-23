import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapidb/providers/db_provider.dart';
import 'package:flutterapidb/providers/employee_api_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api to Sqlite'),
actions: <Widget>[
        IconButton(
    icon: Icon(Icons.settings_input_antenna),
    onPressed: () async {
       await _loadFromApi();
    },
  ),
],
      ),

      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }


  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.blueAccent,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              /* return ListTile(
                leading: Text(
                  "${index + 1}",
                  style: TextStyle(fontSize: 20.0),
                ),
                title: Text(
                    "Name: ${snapshot.data[index].firstName}"
                        " ${snapshot.data[index].lastName} "),
                      subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
              );*/

              // show data from api
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("ID: ${snapshot.data[index].id}"),
                    Text("Name: ${snapshot.data[index].firstName}"),
                    Text("LastName: ${snapshot.data[index].lastName}"),
                    Text("Email: ${snapshot.data[index].email}"),

                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}