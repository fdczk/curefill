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
  int refillsCounted = 0;
  int refillsLeft = 25;


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
      debugShowCheckedModeBanner: false, // removes debug banner
      title: 'Flutter Demo',
      theme: _isDarkMode
          ? ThemeData
          .dark().copyWith(
              colorScheme: ColorScheme.fromSeed (seedColor: const Color.fromRGBO(35, 31, 32, 1)).copyWith(
                  primary: Color.fromRGBO(102, 70, 177, 1),
                  secondary:  Color.fromRGBO(58, 28, 129, 0.5), // darker text for buttons
                  surface: Color.fromRGBO(89, 206, 196, 1), // accent
                  tertiary: Color.fromRGBO(246,246,248,1) // text 
                ),
              useMaterial3: true,
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(246,246,248,100)).copyWith(
                  primary: Color.fromRGBO(89, 206, 196, 1),
                  secondary: Color.fromRGBO(24, 75, 129, 0.5), // darker text for buttons
                  surface: Color.fromRGBO(254, 127, 45, 1), // accent
                  tertiary: Color.fromRGBO(35, 31, 32, 1) // text 
                ),
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text("CURefill", 
              style:TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 30, fontWeight: FontWeight.w500)),
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
              // Chat tab displaying the three closest buildings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Closest Refill Stations:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CIF - 0.5 miles away",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Union - 0.8 miles away",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Armory - 1.2 miles away",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              Scaffold(
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Spacer(flex: 1),
                        const Text (
                          "REFILL(S) TO GO",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                    // IconButton(
                    //   icon: Image.asset('curefill_flutter_application_1/assets/qrbutton_black.png.png'),
                    //   iconSize: 50,
                    //   onPressed: () {},
                    // )
                  ],
                )
              ),
              // const Icon(Icons.water_drop), // temporary fillers for each tab's body
              Scaffold(
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
