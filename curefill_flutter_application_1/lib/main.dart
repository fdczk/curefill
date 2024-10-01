import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CURefill'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late gmaps.GoogleMapController mapController;

  final gmaps.LatLng _center = const gmaps.LatLng(40.112442053296135, -88.22833394110455);

  void _onMapCreated(gmaps.GoogleMapController controller) {
    mapController = controller;
  }
  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    
    return DefaultTabController(length: 4, child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("CURefill"),
          ),
        bottomNavigationBar: BottomAppBar(child: 
          const TabBar(
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
                      position: gmaps.LatLng(40.112442053296135, -88.22833394110455),
                      infoWindow: gmaps.InfoWindow(
                        title: "CIF",
                        snippet: "Closest Refill Station: 3rd floor, north side",
                      ),
                    )
                  },
                ),
              ),
              const Icon(Icons.settings),
            ],
          ),
      )
    );
  }
}
