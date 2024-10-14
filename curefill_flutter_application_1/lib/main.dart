import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:flutter_web_qrcode_scanner/flutter_web_qrcode_scanner.dart';
import 'package:gif_view/gif_view.dart';

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
  bool popupVisible = false;
  Widget popup = SizedBox.shrink();
  List<String> facts = ["Placeholder: This is a fact about water bottles.", 
    "Placeholder: Single-use water bottles release X chemical into the ocean.",
    "Placeholder: Over 50% of whales don't even know what a water bottle is."];
  double bottleSize = 16.9; // Default bottle size in oz
  

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
            refillsCounted += (bottleSize / 16.9).round(); // Increment by ounces of bottle / 16.9
            refillsLeft--; // Decrement refillsLeft
          });
        },
        
        hidePopup: () {
          setState(() {
            popup = SizedBox.shrink();
          });
        },

        createPopup: (List<String> passedFacts) {
          setState(() {
            popup = ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack (
                    alignment: Alignment.center,
                    children: [
                      Image.asset(_isDarkMode ? 'assets/backgrounddark.jpg' : 'assets/backgroundlight.jpg', scale: 2),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center, // vertical
                        crossAxisAlignment: CrossAxisAlignment.center, // horizontal
                        children: [
                        Text(
                          "Success!",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${refillsLeft - 1}", // Update to show refillsLeft
                          style: const TextStyle(fontSize: 150, fontWeight: FontWeight.w800, height: 1)
                        ),
                        const Text(
                          "REMAINING",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                                popup = SizedBox.shrink(); // Hide the popup
                              });
                          },
                          child: Text('Click Here to Close', 
                            style: TextStyle(color: _isDarkMode ? Color.fromRGBO(246, 246, 248, 0.5) : Color.fromRGBO(35, 31, 32, 0.5), fontWeight: FontWeight.w500)),
                          style: ButtonStyle(
                            alignment: Alignment.center, // <-- had to set alignment
                            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.zero, // <-- had to set padding to zero
                            ),
                          ),
                        ),
                    ])],
                  )
                );
          });
        },
        
        refillsLeft: refillsLeft,
        facts: facts,
        popup: popup,
        updateBottleSize: (size) {
          setState(() {
            bottleSize = size; // Update the bottle size
          });
        },
        
        bottleSize: bottleSize, // Pass the bottleSize variable
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
    required this.createPopup,
    required this.hidePopup,
    required this.refillsLeft,
    required this.updateBottleSize,
    required this.popup,
    required this.facts,
    required this.bottleSize, // Add bottleSize
  });

  final String title;
  final VoidCallback toggleTheme;
  final bool Function() returnDark;
  final int refillsCounted;
  final VoidCallback incrementRefills;
  final int refillsLeft;
  final List<String> facts;
  final Function(List<String>) createPopup;
  final Function() hidePopup;
  final Function(double) updateBottleSize; // Add this line
  final double bottleSize; // Add this line
  final Widget popup; // (null essentially -- smallest box possible)

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  late gmaps.GoogleMapController mapController;

  final gmaps.LatLng _center =
      const gmaps.LatLng(40.10594609467735, -88.22840093210742);

  void _onMapCreated(gmaps.GoogleMapController controller) {
    mapController = controller;
  }

  final TextEditingController _bottleSizeController = TextEditingController();

  String? _data;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("CURefill",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 30, fontWeight: FontWeight.w500)),
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.water_drop)),
              Tab(icon: Icon(Icons.camera_alt_rounded)),
              Tab(icon: Icon(Icons.location_pin)),
              Tab(icon: Icon(Icons.settings))
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
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
                  Stack (
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
                          widget.createPopup(widget.facts);
                          widget.incrementRefills(); // Call the increment function
                          debugPrint("The QR code has been clicked! New refillsCounted: ${widget.refillsCounted}");
                          _tabController.index = 2;
                        },
                      ),
                      const Spacer(flex: 1),
                      Text(
                        "You've refilled your bottle [${widget.refillsCounted}] times now. \n That's the equivalent of saving [${(widget.refillsCounted * widget.bottleSize / 16.9).toStringAsFixed(1)}] bottles!",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 3),
                    ],
                  ), (widget.popup),]),
                ],
              )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _data == null
                    ? Container()
                    : Center(
                        child: Text(
                          _data!,
                          style: const TextStyle(fontSize: 18, color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                FlutterWebQrcodeScanner(
                  cameraDirection: CameraDirection.back,
                  onGetResult: (result) {
                    setState(() {
                      _data = result;
                    });
                  },
                  stopOnFirstResult: true,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  onError: (error) {
                    // print(error.message)
                  },
                  onPermissionDeniedError: () {
                    //show alert dialog or something
                  },
                ),
              ],
            ),
            Scaffold(
              body: gmaps.GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: gmaps.CameraPosition(
                  target: _center,
                  zoom: 17.0,
                ),
                markers: {
                  const gmaps.Marker(
                    markerId: gmaps.MarkerId('Gregory Hall'),
                    position: gmaps.LatLng(40.10594609467735, -88.22840093210742),
                    infoWindow: gmaps.InfoWindow(
                      title: "Gregory Hall",
                      snippet: "Closest Refill Station: 2nd floor, south side",
                    ),
                  ),
                  const gmaps.Marker(
                    markerId: gmaps.MarkerId('Smith Memorial Hall'),
                    position: gmaps.LatLng(40.10599746075856, -88.22611080332402),
                    infoWindow: gmaps.InfoWindow(
                      title: "Smith Memorial Hall",
                      snippet: "Closest Refill Station: Lower Level, west side",
                    ),
                  ),
                  const gmaps.Marker(
                    markerId: gmaps.MarkerId('Main Library'),
                    position: gmaps.LatLng(40.10497991005055, -88.22832094361989),
                    infoWindow: gmaps.InfoWindow(
                      title: "Main Library",
                      snippet: "Closest Refill Station: 1st floor, north side",
                    ),
                  )
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _bottleSizeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Bottle Size (oz)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      double? size = double.tryParse(value);
                      if (size != null) {
                        widget.updateBottleSize(size);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: widget.toggleTheme, // Toggle light/dark mode
                    child: const Text('Switch Light/Dark Mode'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
