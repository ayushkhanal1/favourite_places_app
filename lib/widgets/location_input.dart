import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});
  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Location? pickedlocation;
  var isgettinglocation = false;
  void getcurrentlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isgettinglocation = true;
    });
    locationData = await location.getLocation();
    print(locationData.latitude);
    print(locationData.longitude);
    setState(() {
      isgettinglocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget preview = const Text(
      'NO LOCATION CHOOSEN',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    );
    if (isgettinglocation) {
      preview = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
          ),
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          child: preview,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getcurrentlocation,
              icon: const Icon(Icons.location_on),
              label: const Text('GET CURRENT LOCATION'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('PICK LOCATION ON MAP'),
            )
          ],
        )
      ],
    );
  }
}
