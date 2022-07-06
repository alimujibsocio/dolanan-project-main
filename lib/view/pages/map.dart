import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'chat.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

Set<Marker> markers = <Marker>{};

class _MapWidgetState extends State<MapWidget> {
  loc.Location location = loc.Location();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1000,
      interval: 10,
    );
    location.onLocationChanged.listen((LocationData cLoc) async {
      //markers.clear();

      await FirebaseFirestore.instance
          .collection("positions")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "latitude": cLoc.latitude,
        "longitude": cLoc.longitude,
      });
      setState(() {});
    });
    loadByHobbies();
  }

  var selectedHobbies = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data as QuerySnapshot;
                var docs = data.docs;
                List<String> hobbies = [];
                for (var obj in docs) {
                  if (!hobbies.contains(obj["hobby"].toString())) {
                    hobbies.add((obj["hobby"].toString()));
                  }
                }

                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hobbies.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                selectedHobbies = hobbies[index];
                                loadByHobbies();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.star,
                                        color: selectedHobbies == hobbies[index]
                                            ? Colors.red
                                            : Colors.green),
                                    const SizedBox(height: 10),
                                    Text(hobbies[index].toUpperCase()),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ));
              } else {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Container());
              }
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Container(
              child: GoogleMap(
                mapToolbarEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                markers: markers,
                mapType: MapType.normal,
                onMapCreated: (ctrl) async {
                  var loc = await location.getLocation();
                  if (markers.isEmpty) {
                    markers.add(Marker(
                      consumeTapEvents: true,
                      markerId: const MarkerId("current"),
                      position: LatLng(loc.latitude!, loc.longitude!),
                    ));
                  } else {
                    var temp = markers.toList();
                    temp[0] = Marker(
                      consumeTapEvents: true,
                      markerId: const MarkerId("current"),
                      position: LatLng(loc.latitude!, loc.longitude!),
                    );
                    markers = temp.toSet();
                  }
                  ctrl.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(loc.latitude!, loc.longitude!),
                          zoom: 18)));
                  //_controller.complete(ctrl);
                },
                zoomControlsEnabled: true,
                buildingsEnabled: true,
                indoorViewEnabled: true,
                compassEnabled: true,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-6.1773633, 106.7884836),
                  zoom: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadByHobbies() async {
    EasyLoading.show(status: 'loading...');
    if (markers.length > 0) {
      var temp = markers.first;
      markers.clear();
      markers.add(temp);
    }
    var messages =
        await FirebaseFirestore.instance.collection('positions').get();
    {
      for (var message in messages.docs.toList()) {
        var uid = message["uid"];
        var user =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();
        if (uid != FirebaseAuth.instance.currentUser!.uid) {
          if (user["hobby"] == selectedHobbies) {
            markers.add(Marker(
              onTap: () async {
                await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              user["photo_url"].toString(),
                              width: 100,
                              height: 100,
                            ),
                            Column(
                              children: [
                                Text(user["name"].toString(),
                                    style: TextStyle(fontSize: 20)),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    launchUrlString(
                                        "tel://${user["nomor_hp"]}");
                                  },
                                  child: Text(
                                    user["nomor_hp"].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (_) {
                                          return ChatWidget(FirebaseAuth
                                              .instance.currentUser!.uid);
                                        });
                                  },
                                  icon: const Icon(Icons.chat),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
              markerId: MarkerId(uid.toString()),
              position: LatLng(message["latitude"], message["longitude"]),
            ));
          }
        }
      }
    }
    EasyLoading.dismiss();
    setState(() {});
  }
}
