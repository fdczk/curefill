import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Track the theme mode (light/dark)
  bool _isDarkMode = false;

  // Method to toggle between light and dark mode
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
      home: MyHomePage(
        title: 'CURefill',
        toggleTheme: _toggleTheme, // Pass the toggle function to the home page
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.toggleTheme});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final VoidCallback toggleTheme; // Add a toggleTheme callback

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late gmaps.GoogleMapController mapController;

  final gmaps.LatLng _center =
      const gmaps.LatLng(40.112442053296135, -88.22833394110455);

  void _onMapCreated(gmaps.GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _toggleTheme method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("CURefill"),
          ),
          bottomNavigationBar: const BottomAppBar(
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.water_drop)),
                Tab(icon: Icon(Icons.location_pin)),
                Tab(icon: Icon(Icons.settings))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              const Icon(Icons.chat), // temporary fillers for each tab's body
              const Icon(Icons.water_drop),
              Scaffold(
                // appBar: AppBar(
                //   title: const Text('Sydney'), backgroundColor: Colors.green[700]),
                body: gmaps.GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: gmaps.CameraPosition(
                    target: _center,
                    zoom: 20.0,
                  ),
                  markers: {
                    const gmaps.Marker(
                      markerId: gmaps.MarkerId('CIF'),
                      position:
                          gmaps.LatLng(40.112442053296135, -88.22833394110455),
                      infoWindow: gmaps.InfoWindow(
                        title: "CIF",
                        snippet: "Closest Refill Station: 3rd floor, north side",
                      ),
                    )
                  },
                ),
              ),
              // Settings tab with a button to toggle light/dark mode
              Center(
                child: ElevatedButton(
                  onPressed: widget.toggleTheme, // Toggle light/dark mode
                  child: const Text('Switch Light/Dark Mode'),
                ),
              ),
            ],
          ),
        ));
  }
}
