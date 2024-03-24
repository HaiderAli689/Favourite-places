import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_places.dart';

class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlaceScreenState();
  }
}
class _PlaceScreenState extends ConsumerState<PlaceScreen>{

  late Future<void> _placesFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _placesFuture = ref.read(userPlaceProvider.notifier).loadPaces();
  }

  @override
  Widget build(BuildContext context) {

    final userPlaces = ref.watch(userPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddPlaceScreen()),
              );
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
            builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting ?
        const Center(child: CircularProgressIndicator(),) :
        PlacesList(places: userPlaces),)

      ),
    );
  }


}
