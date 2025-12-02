import '../../domain/entities/cat.dart';

class CatModel extends Cat {
  CatModel({
    required String id,
    required String name,
    required String image,
    required String description,
    required String origin,
    required int intelligence,
  }) : super(
         id: id,
         name: name,
         image: image,
         description: description,
         origin: origin,
         intelligence: intelligence,
       );

  factory CatModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = 'https://via.placeholder.com/150';
    if (json['image'] != null && json['image']['url'] != null) {
      imageUrl = json['image']['url'];
    } else if (json['reference_image_id'] != null) {
      imageUrl =
          'https://cdn2.thecatapi.com/images/${json['reference_image_id']}.jpg';
    }

    return CatModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      image: imageUrl,
      description: json['description'] ?? '',
      origin: json['origin'] ?? '',
      intelligence: json['intelligence'] ?? 0,
    );
  }
}
