

import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/loaction_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {

  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace(){
    final enterdTitle = _titleController.text;
    if( enterdTitle.isEmpty || _selectedImage == null || _selectedLocation == null){
      return ;
    }
    ref.read(userPlaceProvider.notifier).addPlace(enterdTitle, _selectedImage!, _selectedLocation! );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Place"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Title",
              ),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 16,),
            ImageInput(onPickImage: (image){
              _selectedImage = image;
            },),
            SizedBox(height: 10,),
            LocationInput(onSelectedLocation: (location){
              _selectedLocation = location;
            },),
            SizedBox(height: 16,),
            ElevatedButton.icon(onPressed: _savePlace,
                label: Text("Add Place"),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
