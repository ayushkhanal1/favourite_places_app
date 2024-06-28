import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({required this.title, required this.image,String? id}) : id =id?? uuid.v4();
  final String title;
  final String id;
  final File image;
}