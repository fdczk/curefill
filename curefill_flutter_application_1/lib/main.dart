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

  bool _returnDark() {
    return _isDarkMode;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // removes debug banner
      title: 'Flutter Demo',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(35, 31, 32, 1)).copyWith(
                primary: Color.fromRGBO(102, 70, 177, 1),
                secondary: Color.fromRGBO(58, 28, 129, 0.5),
                surface: Color.fromRGBO(89, 206, 196, 1),
                tertiary: Color.fromRGBO(246, 246, 248, 1),
              ),
              useMaterial3: true,
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(246, 246, 248, 100)).copyWith(
                primary: Color.fromRGBO(89, 206, 196, 1),
                secondary: Color.fromRGBO(24, 75, 129, 0.5),
                surface: Color.fromRGBO(254, 127, 45, 1),
                tertiary: Color.fromRGBO(35, 31, 32, 1),
              ),
              useMaterial3: true,
            ),
      home: MyHomePage(
        title: 'CURefill',
        toggleTheme: _toggleTheme,
        returnDark: _returnDark,
        refillsCounted: refillsCounted,
        incrementRefills: () {
          setState(() {
            refillsCounted++;
            refillsLeft--; // Decrement refillsLeft
          });
        },
        refillsLeft: refillsLeft, // Pass the refillsLeft variable
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.toggleTheme,
    required this.returnDark,
    required this.refillsCounted,
    required this.incrementRefills,
    required this.refillsLeft, // Add refillsLeft
  });

  final String title;
  final VoidCallback toggleTheme;
  final bool Function() returnDark;
  final int refillsCounted;
  final VoidCallback incrementRefills;
  final int refillsLeft; // Add this line

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("CURefill",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 30, fontWeight: FontWeight.w500)),
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
                      const Spacer(flex: 5),
                      Text(
                        "${widget.refillsLeft}", // Update to show refillsLeft
                        style: const TextStyle(fontSize: 150, fontWeight: FontWeight.w800, height: 1)),
                      const Text(
                        "REFILL(S) TO GO",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(flex: 4),
                      IconButton(
                        icon: Image.asset(widget.returnDark() ? 'assets/qrbutton_purple2.png' : 'assets/qrbutton_blue2.png', scale: 7),
                        iconSize: 1,
                        onPressed: () {
                          widget.incrementRefills(); // Call the increment function
                          debugPrint("The QR code has been clicked! New refillsCounted: ${widget.refillsCounted}");
                        },
                      ),
                      const Spacer(flex: 1),
                      Text(
                        "You've refilled your bottle [${widget.refillsCounted}] times now. \n That's the equivalent of saving [${widget.refillsCounted * 2}] bottles!",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ],
              )
            ),
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
                    position: gmaps.LatLng(40.112442053296135, -88.22833394110455),
                    infoWindow: gmaps.InfoWindow(
                      title: "CIF",
                      snippet: "Closest Refill Station: 3rd floor, north side",
                    ),
                  )
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: widget.toggleTheme, // Toggle light/dark mode
                child: const Text('Switch Light/Dark Mode'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
