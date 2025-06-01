import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';
import 'package:tubes_5_c_travel/common/models/jadwal.dart';
import 'package:intl/intl.dart';
import 'package:tubes_5_c_travel/home/screens/pilih_jadwal.dart';
import 'package:location/location.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  DateTime? selectedDate;
  int passengerCount = 1;
  String? fromLocation;
  String? toLocation;
  final List<String> locations = listKota.keys.toList();

  Location location = Location();
  bool isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    resetHalaman();
    _checkLocationPermission();
  }

  void resetHalaman() {
    selectedDate = null;
    passengerCount = 1;
    fromLocation = null;
    toLocation = null;
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

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
      isLocationPermissionGranted = true;
    });

    if (isLocationPermissionGranted) {
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!isLocationPermissionGranted) return;

    BuildContext? dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Center(
            child: CircularProgressIndicator(
          color: themeColor,
        ));
      },
    );

    try {
      final LocationData currentLocation = await location.getLocation();
      String kotaTerdekat = cariKotaTerdekat(
          currentLocation.latitude!, currentLocation.longitude!);

      setState(() {
        fromLocation = kotaTerdekat;
      });

      print(
          'Lat: ${currentLocation.latitude}, Long: ${currentLocation.longitude}');

      if (dialogContext != null) {
        Navigator.pop(dialogContext!);
      }
    } catch (e) {
      print("Error fetching location: ${e.toString()}");
    }
  }

  String cariKotaTerdekat(double latitude, double longitude) {
    double minDistance = double.infinity;
    String kotaTerdekat = "";

    koordinatKota.forEach((kota, coordinates) {
      final double cityLat = coordinates['lat']!;
      final double cityLong = coordinates['long']!;

      double distance =
          Geolocator.distanceBetween(latitude, longitude, cityLat, cityLong);

      if (distance < minDistance) {
        minDistance = distance;
        kotaTerdekat = kota;
      }
    });

    return kotaTerdekat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Where do you want to go?',
          style: TextStyles.poppinsBold(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Location Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'From',
                        style: TextStyles.poppinsNormal(fontSize: 15),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: fromLocation,
                    hint: Text(
                      "Pilih Lokasi",
                      style: TextStyles.poppinsNormal(fontSize: 15),
                    ),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        fromLocation = newValue;
                      });
                    },
                    items:
                        locations.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyles.poppinsNormal(fontSize: 18),
                        ),
                      );
                    }).toList(),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'To',
                        style: TextStyles.poppinsNormal(fontSize: 15),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: toLocation,
                    hint: Text(
                      "Pilih Lokasi",
                      style: TextStyles.poppinsNormal(fontSize: 15),
                    ),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        toLocation = newValue;
                      });
                    },
                    items:
                        locations.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyles.poppinsNormal(fontSize: 18),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Date Input
            GestureDetector(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                if (date != null && date != selectedDate) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      selectedDate == null
                          ? 'Pilih Tanggal'
                          : 'Tanggal: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                      style: TextStyles.poppinsNormal(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Passenger Count Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Jumlah Penumpang ',
                    style: TextStyles.poppinsNormal(fontSize: 15),
                  ),
                  Spacer(),
                  DropdownButton<int>(
                    value: passengerCount,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (int? newValue) {
                      setState(() {
                        passengerCount = newValue!;
                      });
                    },
                    items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (fromLocation == null ||
                      toLocation == null ||
                      selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Please select both locations and a date."),
                      ),
                    );
                    return;
                  } else {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: PilihJadwal(
                        fromLocation: fromLocation!,
                        toLocation: toLocation!,
                        selectedDate: selectedDate!,
                        passengerCount: passengerCount,
                      ),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  }
                  // Handle search action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Search',
                  style:
                      TextStyles.poppinsBold(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
