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
  List<Marker> _markers = <Marker>[];
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  static final CameraPosition _startCameraPosition = CameraPosition(
    target: LatLng(34.547881, 134.997071),
    zoom: 16,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    _addMarkers();
    _addPolylines();

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _startCameraPosition,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(_markers),
        polylines: Set<Polyline>.of(_polylines.values),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _addMarkers() async {
    List<Marker> markers = <Marker>[];
    List<LatLng> points = _createPoints();

    for (int i = 0; i < points.length; i++) {
      final MarkerId markerId = MarkerId('marker_id_${i + 1}');

      BitmapDescriptor numIcon;
      await _createMarkerImageFromAsset('assets/icons/nums/marker_${i+1}.png')
          .then((value) {
            numIcon = value;
          });

      final Marker marker = Marker(
        markerId: markerId,
        position: points[i],
        infoWindow: InfoWindow(
            title: 'marker_${i + 1}', snippet: '*'),
        icon: numIcon,
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () {},
      );

      markers.add(marker);
    }

    setState(() {
      _markers.addAll(markers);
    });
  }

  Future<BitmapDescriptor> _createMarkerImageFromAsset(String assetName) async {
    final ImageConfiguration imgConfig = ImageConfiguration();

    return BitmapDescriptor.fromAssetImage(imgConfig, assetName);
  }

  void _addPolylines() {
    final String polylineIdVal1 = 'polilyne_id_1';
    final PolylineId polylineId1 = PolylineId('polilyne_id_1');

    final Polyline polyline1 = Polyline(
      polylineId: polylineId1,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: _createPoints(),
      onTap: () {},
    );

    setState(() {
      _polylines[polylineId1] = polyline1;
    });
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[
      LatLng(34.549551, 134.996050),
      LatLng(34.547671, 134.999087),
      LatLng(34.546679, 134.998176),
      LatLng(34.547888, 134.996276),
      LatLng(34.548428, 134.996758),
    ];
    return points;
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = _controller;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}