import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/components/custom_navbar.dart';
import 'package:plant_disease_classifier/screens/pages/prediction.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set();

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      markers.clear(); // Clear existing markers
      markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(title: 'Pinned Location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        automaticallyImplyLeading: false,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Initial map center
          zoom: 10.0, // Initial zoom level
        ),
        markers: markers,
        onTap: _onMapTapped,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(220, 68, 241, 166),
                  offset: Offset(0, 22),
                  blurRadius: 50)
            ],
            color: Color.fromARGB(255, 68, 241, 166),
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Prediction()),
              );
            },
            child: ImageIcon(AssetImage('assets/nav/scan-default.png'),
                size: 35, color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(50), // Adjust the radius as needed
            ),
          )),
    );
  }
}
