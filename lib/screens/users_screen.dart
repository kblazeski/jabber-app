import 'package:flutter/material.dart';
import 'package:jabber_app/service/firebase_service.dart';
import 'package:jabber_app/widgets/user/user_card.dart';
import 'package:jabber_app/widgets/user/users.dart';
import 'package:location/location.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  void enableLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    print(_locationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: [
          DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ]),
                  ),
                  value: 'logout',
                ),
                DropdownMenuItem(
                  child: Container(
                    child: Row(children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Enable location'),
                    ]),
                  ),
                  value: 'location',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseService.signOutUser();
                }
                if (itemIdentifier == 'location') {
                  enableLocation();
                }
              })
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Users(),
      ),
    );
  }
}
