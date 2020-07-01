import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moviesapp/movies.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url = "https://api.themoviedb.org/3/movie/top_rated?api_key=4dcdb81b0222dcc00d764b4d9e2fd20a";
  MoviesDb moviesDb;

  Future getData() async {
    var response = await http.get(url);
  var jsonData = jsonDecode(response.body);
  moviesDb = MoviesDb.fromJson(jsonData);
  setState(() {

  });
//  debugPrint(moviesDb.toString());
//  setState(() {
//    moviesData = data["data"];
//  });
//    debugPrint(moviesData.toString());
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        centerTitle: true,
      ),
      body: moviesDb == null ? Center(
        child: CircularProgressIndicator(),
      ) : GridView.count(
          crossAxisCount: 2,
        children:
    moviesDb.results.map((movie) => Padding(
          padding: EdgeInsets.all(2.0),
      child: InkWell(
        onTap: (){
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => new DetailScreen(results: movie,))
         );
        },
        child: Hero(
          tag: movie.posterPath,
          child: Card(
            semanticContainer: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(color: Colors.amber),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                      cacheHeight: 152,
                      cacheWidth: 200,
                    ),
                  ),
                  Text(
                    movie.title,
                    style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          ),
        ),
      ),
      ),
      ).toList()
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Results results;
  DetailScreen({this.results});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text("Movies Details"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
         Card(
           child:  Container(
             child: Column(
               children: <Widget>[
                 Image.network("https://image.tmdb.org/t/p/w200${this.results.posterPath}",fit: BoxFit.fill,)
               ],
             ),
           ),
         ),
          Text(this.results.title,style: GoogleFonts.roboto(fontSize: 20),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
               Text(this.results.originalTitle,style: GoogleFonts.aclonica(fontSize: 15),),
               Text(this.results.releaseDate,style: GoogleFonts.amita(fontSize: 15,fontWeight: FontWeight.bold),),
           ],
          ),
          SizedBox(height: 20,),
          Text(this.results.overview,style: GoogleFonts.aladin(fontSize: 20),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Rating : " + this.results.voteAverage.toString(),style: GoogleFonts.acme(fontSize: 20),),
              Text("Voting : " + this.results.voteCount.toString(),style: GoogleFonts.adventPro(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          )

        ],
      )
    );
  }
}

