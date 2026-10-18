import 'review.dart';

enum StayType {
  hotel('Hotel'),
  hostel('Hostel'),
  guestHouse('Guest House');

  final String label;
  const StayType(this.label);
}

class Stay {
  final String id;
  final String name;
  final StayType type;
  final String city;
  final String area; // e.g. F-6, I-14
  final String address;
  final int pricePerNight; // PKR
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String description;
  final List<String> amenities;
  final double foodRating;
  final String foodInfo;
  final bool mealsIncluded;
  final List<String> perks;
  final String? offer;
  final String nearby;
  final bool familyFriendly;
  final bool hasCctv;
  final List<Review> reviews;

  const Stay({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.area,
    required this.address,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.description,
    required this.amenities,
    required this.foodRating,
    required this.foodInfo,
    required this.mealsIncluded,
    required this.perks,
    required this.nearby,
    required this.reviews,
    this.offer,
    this.familyFriendly = true,
    this.hasCctv = true,
  });
}
