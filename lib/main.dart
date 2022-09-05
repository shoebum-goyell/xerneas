import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xerneas/NewTask.dart';
import 'dart:async';
import 'package:xerneas/markertype.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xerneas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Xerneas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    super.initState();
  }

  Position _pos = Position();
  LatLng latLng = LatLng(0, 0);
  static double lat = 0;
  static double long = 0;
  static double a = 0;
  List<String> s = [];
  GoogleMapController mapController;
  double zoomVal = 17.0;
  List<double> lats = [];
  List<double> longs = [];
  List<double> distances = [];
  List<String> grades = [];
  List<String> boards = [];
  List<String> materials = [];
  int m = 0;


  @override
  Widget build(BuildContext context) {

    _getpos();
    _getmarkers();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: Transform.scale(
        scale: 1.25,
        child: FloatingActionButton(onPressed: _gotomyLocation
        , child: Icon(FontAwesomeIcons.locationArrow,
          color: Colors.orange,),
          backgroundColor:Colors.white,
          ),
      ),

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MarkerType(), fullscreenDialog: true),
          );},
        ),
        title: Text("Xerneas Home Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.plus),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewTask(), fullscreenDialog: true),
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _buildContainer(),
          printCards(lats, longs, grades, boards, materials,distances),

      ],
      ),
    );
  }

  Widget _buildContainer() {

        return Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: StreamBuilder(
              stream: Firestore.instance.collection('marker').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost =
                        snapshot.data.documents[index];
                        if(lats.contains(mypost['latitude']) && materials.contains(mypost['material']))
                          {
                            return Container();
                          }
                        else{
                          lats.add(mypost['latitude']);
                          longs.add(mypost['longitude']);
                          grades.add( mypost['grade']);
                          s.add(mypost['contact_info']);
                          materials.add( mypost['material']);
                          boards.add( mypost['board']);

                          return Container();
                        }

                      });
                } else {
                  return Text("Loading");
                }
              }),
        );
  }

  Widget _boxes(
      double lat,
      double long,
      String board,
      String grade,
      String material
      ) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
            child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [const Color(0xffffe699), const Color(0xffff9900)])
                    , borderRadius: BorderRadius.circular(25.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: myDetailsContainer1(board, grade,material),
                          ),
                        ),
                      ],
                    )))),
      ),
    );
  }

  Widget myDetailsContainer1(String board, String grade, String material) {
    int l = material.length;
    double k = l/2;
    int j = k.toInt();


    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Text(
                "Grade :" + grade,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )),
        ),

        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "Board :",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21.0,
                      ),
                    )),
                Container(
                    child: Text(
                      board,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21.0,
                      ),
                    )),
              ],
            )),

        Container(
            child: Text(
              "Material:" + material.substring(0,j),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),
            )),

        Container(
            child: Text(
              material.substring(j,l),
              style: TextStyle(
                  color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 19,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
  Future<void> _gotomyLocation() async {
    _getpos();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 19,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }


  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        mapType: MapType.normal,
        markers: _markers.values.toSet(),
        initialCameraPosition:
        CameraPosition(target: LatLng(lat, long), zoom: 17),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  final Map<String, Marker> _markers = {};
  Future<void> _getpos() async {

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    double a = position.latitude;
    double b = position.longitude;
    lat = a;
    long = b;

    latLng = LatLng(lat, long);

    setState(() {


      _pos = position;
      lat = a;
      latLng = LatLng(lat, long);
      long = b;

      if(m!=1){
        getdist();
      }

    });
  }



  Future<void> _getmarkers() async {


    setState(() {
      for (int i = 0; i < lats.length; i++) {
        if (grades[i] == '9'){

          final mar = Marker(
              markerId: MarkerId(s[i]),
              position: LatLng(lats[i], longs[i]),
              infoWindow: InfoWindow(
                snippet: materials[i],
                title: s[i],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueCyan));

          _markers[s[i]] = mar;
        }
        else if (grades[i] == '10'){

          final mar = Marker(
              markerId: MarkerId(s[i]),
              position: LatLng(lats[i], longs[i]),
              infoWindow: InfoWindow(
                snippet: materials[i],
                title: s[i],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed));

          _markers[s[i]] = mar;
        }
        else if (grades[i] == '11'){

          final mar = Marker(
              markerId: MarkerId(s[i]),
              position: LatLng(lats[i], longs[i]),
              infoWindow: InfoWindow(
                snippet: materials[i],
                title: s[i],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen));

          _markers[s[i]] = mar;
        }
        else if (grades[i] == '12'){

          final mar = Marker(
              markerId: MarkerId(s[i]),
              position: LatLng(lats[i], longs[i]),
              infoWindow: InfoWindow(
                snippet: materials[i],
                title: s[i],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet));

          _markers[s[i]] = mar;
        }

        else{
          final mar = Marker(
              markerId: MarkerId(s[i]),
              position: LatLng(lats[i], longs[i]),
              infoWindow: InfoWindow(
                snippet: materials[i],
                title: s[i],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow));

          _markers[s[i]] = mar;
        }

      }
    });
  }
  Widget printCards(List<double> lats,List<double> longs,List<String> grades,List<String> boards,List<String> materials,List<double> distances){

    for(int i = 0; i< distances.length; i++){
      for(int j =0; j<(distances.length-i-1); j++)
        {

            if(distances[j] > distances[j+1])
            {
              double tempd = distances[j];
              distances[j] = distances[j+1];
              distances[j+1] = tempd;
              double templ = lats[j];
              lats[j] = lats[j+1];
              lats[j+1] = templ;
              double templo = longs[j];
              longs[j] = longs[j+1];
              longs[j+1] = templo;
              String tempb = boards[j];
              boards[j] = boards[j+1];
              boards[j+1] = tempb;
              String tempg = grades[j];
              grades[j] = grades[j+1];
              grades[j+1] = tempg;
              String tempm = materials[j];
              materials[j] = materials[j+1];
              materials[j+1] = tempm;
              String temps = s[j];
              s[j] = s[j+1];
              s[j+1] = temps;
            }

        }
    }

    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView.builder(
             scrollDirection: Axis.horizontal,
             itemCount: lats.length,
             itemBuilder: (context, index) {

               return (_boxes(lats[index], longs[index],
                         boards[index], grades[index],materials[index]));


    })));



  }
  Future<void> getdist() async{
    for(int i  = 0 ; i < longs.length; i++)
      {
        double distanceInMeters = await Geolocator().distanceBetween(lat, long, lats[i], longs[i]);
        distances.add(distanceInMeters);
        m = 1;
      }


  }
}





