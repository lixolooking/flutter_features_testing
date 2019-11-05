import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GuideMapState extends State<GuideMap> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Guide map'),
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.of(context).pop(),
        ),
      ),
      body: MapSample()
    );
  }
}

class GuideMap extends StatefulWidget {
  @override
  GuideMapState createState() => GuideMapState();
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController _controller;
  List<Marker> markers = <Marker>[];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(50.555395, 30.493153),
    zoom: 17,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _addMarkers() {
    final String markerIdVal1 = 'marker_id_1';
    final String markerIdVal2 = 'marker_id_2';

    final MarkerId markerId1 = MarkerId(markerIdVal1);
    final MarkerId markerId2 = MarkerId(markerIdVal2);

    final Marker marker1 = Marker(
      markerId: markerId1,
      position: LatLng(50.555395, 30.493153),
      infoWindow: InfoWindow(
          title: markerIdVal1, snippet: '*'),
      onTap: () {},
    );

    final Marker marker2 = Marker(
      markerId: markerId2,
      position: LatLng(50.555105, 30.493185),
      infoWindow: InfoWindow(
          title: markerIdVal2, snippet: '*'),
      onTap: () {},
    );

    setState(() {
      markers.add(marker1);
      markers.add(marker2);
    });
  }

  void _addPolylines() {
    final String polylineIdVal1 = 'polilyne_id_1';

    final PolylineId polylineId1 = PolylineId(polylineIdVal1);

    final Polyline polyline1 = Polyline(
      polylineId: polylineId1,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: _createPoints(),
      onTap: () {},
    );

    setState(() {
      polylines[polylineId1] = polyline1;
    });
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(LatLng(50.555395, 30.493153));
    points.add(LatLng(50.555105, 30.493185));
    return points;
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = _controller;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  Widget build(BuildContext context) {
    _addMarkers();
    _addPolylines();

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers),
        polylines: Set<Polyline>.of(polylines.values),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}