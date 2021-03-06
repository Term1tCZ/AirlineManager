import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/myFlights.dart';
import '../models/myAirplanes.dart';
import '../models/airplane.dart';

class UserProvider with ChangeNotifier {
  final String _userId;
  UserProvider(this._userId);

  List<User> _user = [];
  List<MyFlights> _myFlights = [];
  List<MyFlights> _myActiveFlights = [];
  List<MyAirplane> _myPlanes = [];
  List<Airplane> _listOfAirlanes = [];
  int countPlanes = 0;
  int countFlights = 0;

  List<User> get user {
    return [..._user];
  }

  List<Airplane> get listOfAirplanes {
    return [..._listOfAirlanes];
  }

  String get userId {
    return _userId;
  }

  List<MyFlights> get myFlights {
    return [..._myFlights];
  }

  List<MyFlights> get myActiveFlights {
    return [..._myActiveFlights];
  }

  List<MyAirplane> get myPlanes {
    return [..._myPlanes];
  }

  Future<void> getUser() async {
    // User.uid = '-M8oXlLa-7hZgyTIR_y8'; //POZOR
    _user = [];
    // print(User.uid);
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=$_userId';

    try {
      var _response = await http.get(url);
      if (_response.statusCode == 200) {
        Map<String, dynamic> _map = convert.jsonDecode(_response.body);

        if (_map == null) {
          return;
        }
        final List<User> _newUser = [
          User(
            id: User.uid,
            username: _map['name'],
            airlineName: _map['airlineName'],
            coins: _map['coins'],
            gems: _map['gems'],
            pilotRank: _map['pilotRank'],
            gameLevel: _map['gameLevel'],
            profilePictureUrl: _map['profilePictureUrl'],
            totalFlightDistance: _map['flightDistance'],
            totalFlightTime: _map['flightTime'],
            created: _map['dateCreation'],
            login: _map['dateLogin'],
          ),
        ];
        _user.add(_newUser[0]);
        // notifyListeners();
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> getPlanes() async {
    _myPlanes = [];

    countPlanes = 0;
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=$_userId';

    try {
      var _response = await http.get(url);
      if (_response.statusCode == 200) {
        Map<String, dynamic> _map = convert.jsonDecode(_response.body);

        if (_map == null) {
          return;
        }

        var _airplanes = _map['aircrafts'];
        for (var item in _airplanes.keys) {
          List<MyAirplane> _preps = [
            MyAirplane(
              id: item,
              name: _airplanes[item]['name'],
              imageUrl: _airplanes[item]['imageUrl'],
              seats: _airplanes[item]['capacity'],
              price: _airplanes[item]['price'],
              onFlight: _airplanes[item]['onFlight'],
              distance: _airplanes[item]['range'],
              totalFlightDistance: _airplanes[item]['totalDistance'],
              speed: _airplanes[item]['speed'],
              totalFlightTime: _airplanes[item]['totalFlightTime'],
              totalFlights: _airplanes[item]['totalFlights'],
              aircraftIdentity: _airplanes[item]['aircraftIdentity'],
              arrivalTime: _airplanes[item]['arrivalTime'],
            ),
          ];
          _myPlanes.add(_preps[0]);
        }
        countPlanes = _myPlanes.length - 1;
        _myPlanes.sort((a, b) => a.name.compareTo(b.name));

        // notifyListeners();
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> getFlights() async {
    _myFlights = [];
    countFlights = 0;
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=persons&personId=$_userId';

    try {
      var _response = await http.get(url);
      if (_response.statusCode == 200) {
        Map<String, dynamic> _map = convert.jsonDecode(_response.body);

        if (_map == null) {
          return;
        }

        if (_map['flights'] != null) {
          _myActiveFlights = [];
          var _flights = _map['flights'];
          int i = 0;
          for (var item in _flights.keys) {
            List<MyFlights> _prepsFlights = [
              MyFlights(
                id: item,
                arrivalDes: _flights[item]['arrivalDes'],
                departureDes: _flights[item]['departureDes'],
                aircraft: _flights[item]['aircraft'],
                departureTime: _flights[item]['departureTime'],
                reward: _flights[item]['reward'],
                onAir: _flights[item]['onAir'],
                flightNumber: _flights[item]['flightNo'],
                flightTime: _flights[item]['flightTime'],
                arrivalTime: _flights[item]['arrivalTime'],
              ),
            ];
            _myFlights.add(_prepsFlights[0]);

            if (DateTime.parse(_myFlights[i].arrivalTime)
                .isAfter(DateTime.now())) {
              print('future');
              _myActiveFlights.add(myFlights[i]);
              _myFlights[i].onAir = true;
            } else {
              _myFlights[i].onAir = false;
              //myActiveFlights.removeAt(0);
              print('done');
            }
            i++;
          }
          countFlights = _myFlights.length - 1;
        }

        // notifyListeners();
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future getAllAirlanes() async {
    const url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/getData?entity=aircrafts';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);

        if (map == null) {
          return;
        }

        for (var item in map.keys) {
          final List<Airplane> _airplaneListDb = [
            Airplane(
              id: item,
              name: map[item]['name'],
              speed: map[item]['speed'],
              price: map[item]['price'],
              seats: map[item]['capacity'],
              distance: map[item]['range'],
              imageUrl: map[item]['imageUrl'],
            ),
          ];
          // print(airplaneListDb[0]);
            _listOfAirlanes.add(_airplaneListDb[0]);
        }

        _listOfAirlanes.sort((a, b) => a.name.compareTo(b.name));
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future buyAirplane(int index) async {
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/buyAircraft?personId=$_userId&aircraftIdentity=${_listOfAirlanes[index].id}';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> map = convert.jsonDecode(response.body);

        if (map == null) {
          return;
        }
        
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }

  Future sell(int index) async {
    var url =
        'https://us-central1-airlines-manager-b7e46.cloudfunctions.net/api/sellAircraft?personId=$_userId&aircraftIdentity=${_myPlanes[index].id}';

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        print('done');
      } else {
        print('error');
      }
    } catch (error) {
      print(error);
    }
  }
}
