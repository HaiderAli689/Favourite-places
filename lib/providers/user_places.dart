import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:riverpod/riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

  Future<Database> _getDatabase() async{
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'Create table user_places (id text primary key, title text,image text, lat Real, lng Real, address text)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPaces() async{
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) => Place(
      id: row['id'] as String,
        location: PlaceLocation(
            latitude: row['lat'] as double,
            longitude: row['lng'] as double,
            //address: row['address'] as String
        ),
        title: row['title'] as String,
        image: File(row['image'] as String)
    )
    ).toList();

    state = places;

  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    state = [newPlace, ...state];


    final db = await _getDatabase();
   db.insert('user_places',{
     'id': newPlace.id,
     'title': newPlace.title,
     'image': newPlace.image,
     //'address': newPlace.location.address,
     'lat': newPlace.location.latitude,
     'lng': newPlace.location.longitude,

   }

   );
  }
}

final userPlaceProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
