// import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:city_codes_slovenija/connectivity_change_notifier.dart';
import 'package:city_codes_slovenija/search_widget.dart';
import 'package:city_codes_slovenija/location.dart';
import 'package:city_codes_slovenija/boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//deletes all explicitly loaded items from the session before from the hive db
  // Hive.deleteFromDisk();

  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());

  await Hive.openBox<Location>('locations');

  // Update the state of the app.
  if (Boxes.getLocations().isEmpty) {
    List<Location> cities = [
      Location(city_name: 'Skopje', city_code: 1000),
      Location(city_name: 'Ljubljana', city_code: 1000),
      Location(city_name: 'Maribor', city_code: 2000),
      Location(city_name: 'Strumica', city_code: 6000),
      Location(city_name: 'Koper', city_code: 6000),
      Location(city_name: 'Malečnik ', city_code: 2229),
      Location(city_name: 'Murska Sobota', city_code: 9000),
      Location(city_name: 'Izola', city_code: 6310),
      Location(city_name: 'Celje', city_code: 3000),
      Location(city_name: 'Ptuj', city_code: 2250),
    ];
    // await Boxes.getLocations().put('sk', city);
    Boxes.getLocations().add(cities[0]);
    Boxes.getLocations().add(cities[1]);
    Boxes.getLocations().add(cities[2]);
    Boxes.getLocations().add(cities[3]);
    Boxes.getLocations().add(cities[4]);
    Boxes.getLocations().add(cities[5]);
    Boxes.getLocations().add(cities[6]);
    Boxes.getLocations().add(cities[7]);
    Boxes.getLocations().add(cities[8]);
    Boxes.getLocations().add(cities[9]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        ConnectivityChangeNotifier changeNotifier =
            ConnectivityChangeNotifier();
        changeNotifier.initialLoad();
        return changeNotifier;
      },
      child: MaterialApp(
        title: 'Internet Connection Notifier',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isOnline = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cities'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchWidget(isOnline: isOnline),
                );
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Center(
        child: Selector<ConnectivityChangeNotifier, bool>(
          selector: (context, connectivityChangeNotifier) =>
              connectivityChangeNotifier.connection_status,
          builder: (context, value, child) {
            if (value) {
              isOnline = true;
              return Text('ONLINE',
                  style: TextStyle(color: Colors.green[200], fontSize: 50));
            } else {
              isOnline = false;
              return Text('OFFLINE',
                  style: TextStyle(color: Colors.red[600], fontSize: 50));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_city),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CitiesList()),
          );
        },
      ),
    );
  }
}

class CitiesList extends StatelessWidget {
  const CitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localy saved Cities'),
      ),

      body: buildContent(Boxes.getLocations().values.toList().cast<Location>()),
      //If a city is added, this will rebuild the list of cities
      // body: ValueListenableBuilder<Box<Location>> ( valueListenable: Boxes.getLocations().listenable(), builder: (context, box, _) {
      //  final locations = box.values.toList().cast<Location>();
      //  return buildContent(locations); }, ),
    );
  }

  Widget buildContent(List<Location> locations) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return Text(
          locations[index].city_code.toString() +
              ' ' +
              locations[index].city_name,
          style: TextStyle(fontSize: 20),
        );
      },
    );
  }
}
