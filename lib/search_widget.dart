import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:city_codes_slovenija/location.dart';
import 'package:city_codes_slovenija/boxes.dart';

class SearchWidget extends SearchDelegate {
  final bool isOnline;
  SearchWidget({required this.isOnline});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // for closing the search page and going back
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query, isOnline: isOnline);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query, isOnline: isOnline);
  }
}

class SearchFinder extends StatefulWidget {
  final String query;
  final bool isOnline;

  const SearchFinder({super.key, required this.query, required this.isOnline});

  @override
  State<SearchFinder> createState() => _SearchFinderState();
}

class _SearchFinderState extends State<SearchFinder> {
  late List<Location> online_results = [];
  final String url =
      'https://raw.githubusercontent.com/mariopanzov/json_files/main/CityCodesSlovenija.json';
  @override
  void initState() {
    createListCityCodesSlovenija();
  }

  void createListCityCodesSlovenija() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseBody = response.body;
      var jsonBody = json.decode(responseBody);
      for (var data in jsonBody) {
        online_results.add(new Location(
            city_name: data['city_name'], city_code: data['city_code']));
      }
    } else {
      print('something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Location> results;
    return widget.isOnline
        ? Builder(builder: ((context) {
            //createListCityCodesSlovenija();

            return resultList(online_results);
          }))
        : ValueListenableBuilder(
            valueListenable: Boxes.getLocations().listenable(),
            builder: (context, Box<Location> locations, _) {
              return resultList(locations.values.toList());
            },
          );
  }

  Widget resultList(List<Location> inputList) {
    List<Location> res;
    if (widget.query.isEmpty) {
      res = inputList.toList(); // whole List
    } else {
      res = inputList
          .where((c) =>
              c.city_name.toLowerCase().contains(widget.query) ||
              c.city_code.toString().contains(widget.query))
          .toList();
    }

    if (res.isEmpty) {
      return Center(child: Text('No results found !'));
    } else {
      return ListView.builder(
        itemCount: res.length,
        itemBuilder: (context, index) {
          return Text(
            res[index].city_code.toString() + ' ' + res[index].city_name,
            style: TextStyle(fontSize: 20),
          );
        },
      );
    }
  }
}
