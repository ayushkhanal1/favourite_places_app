import 'dart:io';

import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});
  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreen();
  }
}

class _AddPlaceScreen extends ConsumerState<AddPlaceScreen> {
  final _titlecontroller = TextEditingController();
  File? _selectedimage;
  void _saveplace() {
    final enteredtext = _titlecontroller.text;
    if (enteredtext.isEmpty||_selectedimage==null) {
      showDialog(
        context: context,
        builder: (context) => const Text('INVALID INPUT'),
      );
      return;
    }
    ref.read(userPlacesProvider.notifier).addplace(enteredtext,_selectedimage!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD NEW PLACE'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              maxLength: 50,
              decoration: const InputDecoration(labelText: 'TITLE'),
              controller: _titlecontroller,
            ),
            const SizedBox(
              height: 10,
            ),
            ImageInput(onpickimage: (img) {
              _selectedimage = img;
            }),
            const SizedBox(
              height: 10,
            ),
            const LocationInput(),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: _saveplace,
              icon: const Icon(Icons.add),
              label: const Text('ADD ITEM'),
            ),
          ],
        ),
      ),
    );
  }
}
