import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Airline Manager'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text('Overview'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Flight Offers'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/offers-screen');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.airplanemode_active),
            title: Text('Inventory'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Airplane shop'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
