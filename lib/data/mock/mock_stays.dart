import '../models/review.dart';
import '../models/stay.dart';

// NOTE: All names, prices and reviews below are FICTIONAL sample data
// for UI development. Images come from picsum.photos (random placeholders).
// Replace with real data when the backend is ready.

List<Review> _reviews() => const [
      Review(
        userName: 'Ali Raza',
        rating: 5,
        comment: 'Clean rooms, friendly staff and the food was great.',
        date: '2 weeks ago',
      ),
      Review(
        userName: 'Hamza Khan',
        rating: 4,
        comment: 'Good value for the price. Location is very convenient.',
        date: '1 month ago',
      ),
      Review(
        userName: 'Sara Ahmed',
        rating: 4.5,
        comment: 'Felt safe and comfortable. Would stay again.',
        date: '2 months ago',
      ),
    ];

Stay _stay(
  int n,
  String name,
  StayType type,
  String area,
  String address,
  int price,
  double rating,
  int count, {
  required String desc,
  required List<String> amenities,
  required double food,
  required String foodInfo,
  required List<String> perks,
  required String nearby,
  bool meals = false,
  String? offer,
  bool family = true,
  bool cctv = true,
}) {
  return Stay(
    id: 'stay_$n',
    name: name,
    type: type,
    city: 'Islamabad',
    area: area,
    address: address,
    pricePerNight: price,
    rating: rating,
    reviewCount: count,
    images: List.generate(
        3, (i) => 'https://picsum.photos/seed/bookme$n$i/800/600'),
    description: desc,
    amenities: amenities,
    foodRating: food,
    foodInfo: foodInfo,
    mealsIncluded: meals,
    perks: perks,
    offer: offer,
    nearby: nearby,
    familyFriendly: family,
    hasCctv: cctv,
    reviews: _reviews(),
  );
}

final List<Stay> mockStays = [
  // ---------------- HOTELS ----------------
  _stay(
    1, 'Margalla View Hotel', StayType.hotel, 'F-6',
    'Street 12, F-6 Markaz, Islamabad', 14500, 4.5, 212,
    desc: 'A comfortable 4-star hotel with Margalla Hills views, '
        'close to Jinnah Super Market and main business areas.',
    amenities: ['Free Wi-Fi', 'AC', 'Parking', 'Restaurant', 'Room Service', 'Gym'],
    food: 4.4,
    foodInfo: 'Buffet breakfast, Pakistani and Continental menu.',
    meals: true,
    perks: ['Free airport pickup on 3+ nights', 'Late check-out on request'],
    offer: '15% off on 3+ nights',
    nearby: 'Jinnah Super Market - 5 min',
  ),
  _stay(
    2, 'Capital Inn Hotel', StayType.hotel, 'Blue Area',
    'Jinnah Avenue, Blue Area, Islamabad', 11800, 4.2, 168,
    desc: 'Business-friendly hotel in the heart of Blue Area. '
        'Ideal for interviews and office visits.',
    amenities: ['Free Wi-Fi', 'AC', 'Parking', 'Restaurant', 'Laundry'],
    food: 4.0,
    foodInfo: 'Breakfast included, 24/7 room service.',
    meals: true,
    perks: ['Walking distance to offices', 'Free tea/coffee in lobby'],
    nearby: 'Centaurus Mall - 8 min',
  ),
  _stay(
    3, 'Pearl Residency', StayType.hotel, 'F-7',
    'Street 5, F-7 Markaz, Islamabad', 18500, 4.6, 305,
    desc: 'Premium stay with spacious rooms, rooftop dining and '
        'excellent service.',
    amenities: ['Free Wi-Fi', 'AC', 'Parking', 'Rooftop Cafe', 'Gym', 'Laundry'],
    food: 4.7,
    foodInfo: 'Rooftop cafe, fresh breakfast and BBQ nights.',
    meals: true,
    perks: ['Free breakfast', 'Complimentary airport drop'],
    offer: 'Weekend special: 10% off',
    nearby: 'Melody Food Park - 10 min',
  ),

  // ---------------- HOSTELS ----------------
  _stay(
    4, 'Student Nest Hostel', StayType.hostel, 'I-14',
    'Sector I-14, Islamabad', 1500, 4.1, 96,
    desc: 'Budget-friendly hostel for students, with study desks and '
        'quiet hours. Close to universities.',
    amenities: ['Wi-Fi', 'Study Desk', 'Laundry', 'Common Room', 'Hot Water'],
    food: 3.8,
    foodInfo: 'Home-style meals available: breakfast and dinner.',
    perks: ['Student ID: 10% off', 'Monthly package available'],
    offer: '10% off with student ID',
    nearby: 'Near Riphah International University',
    family: false,
  ),
  _stay(
    5, 'NUST Nomads Hostel', StayType.hostel, 'H-12',
    'Sector H-12, Islamabad', 1800, 4.3, 134,
    desc: 'Popular with test-takers and visiting students. '
        'Clean dorms and fast internet.',
    amenities: ['Fast Wi-Fi', 'AC Dorms', 'Lockers', 'Laundry', 'Hot Water'],
    food: 4.0,
    foodInfo: 'Mess with 3 meals/day, weekly menu.',
    meals: true,
    perks: ['Lockers included', 'Free tea at night'],
    nearby: 'Near NUST - 3 min walk',
    family: false,
  ),
  _stay(
    6, 'Backpackers Base', StayType.hostel, 'G-11',
    'Markaz, G-11, Islamabad', 1300, 3.9, 71,
    desc: 'Simple, affordable beds for solo travelers and job seekers.',
    amenities: ['Wi-Fi', 'Fan/AC', 'Shared Kitchen', 'Hot Water'],
    food: 3.6,
    foodInfo: 'Shared kitchen plus many cheap restaurants nearby.',
    perks: ['Shared kitchen', '24/7 check-in'],
    nearby: 'G-11 Markaz - 2 min',
    family: false,
  ),
  _stay(
    7, 'Campus Corner Hostel', StayType.hostel, 'Near QAU',
    'Near Quaid-i-Azam University, Islamabad', 1400, 4.0, 88,
    desc: 'Calm hostel near the university, good for exam weeks.',
    amenities: ['Wi-Fi', 'Study Room', 'Laundry', 'Hot Water'],
    food: 3.9,
    foodInfo: 'Breakfast included, dinner optional.',
    meals: true,
    perks: ['Study room open 24/7', 'Weekly cleaning'],
    nearby: 'QAU Gate - 5 min',
    family: false,
  ),

  // ---------------- GUEST HOUSES ----------------
  _stay(
    8, 'Green Valley Guest House', StayType.guestHouse, 'G-9',
    'Street 8, G-9/1, Islamabad', 4500, 4.3, 120,
    desc: 'Cozy guest house with private rooms and a lawn. '
        'Peaceful and secure.',
    amenities: ['Wi-Fi', 'AC', 'Parking', 'Lawn', 'TV'],
    food: 4.2,
    foodInfo: 'Desi breakfast and home-cooked lunch/dinner on order.',
    meals: true,
    perks: ['Free breakfast', 'Tea/coffee all day'],
    offer: 'Stay 3 nights, get 1 free breakfast upgrade',
    nearby: 'Pims Hospital - 10 min',
  ),
  _stay(
    9, 'Family Comfort Guest House', StayType.guestHouse, 'F-8',
    'Street 20, F-8/3, Islamabad', 5500, 4.4, 150,
    desc: 'Family-friendly rooms with a shared lounge and quiet '
        'neighborhood.',
    amenities: ['Wi-Fi', 'AC', 'Parking', 'Kitchenette', 'Lounge'],
    food: 4.3,
    foodInfo: 'Breakfast included, lunch/dinner on request.',
    meals: true,
    perks: ['Family rooms', 'Free parking'],
    nearby: 'F-8 Markaz - 5 min',
  ),
  _stay(
    10, 'Peace Villa Guest House', StayType.guestHouse, 'E-11',
    'Street 3, E-11/2, Islamabad', 4000, 4.0, 82,
    desc: 'Budget guest house with clean rooms and friendly hosts.',
    amenities: ['Wi-Fi', 'AC', 'Parking', 'Hot Water'],
    food: 3.9,
    foodInfo: 'Basic breakfast included, many eateries nearby.',
    meals: true,
    perks: ['Monthly rates available', 'Free laundry (1x/week)'],
    nearby: 'Giga Mall road - 10 min',
  ),
  _stay(
    11, 'Bahria Heights Guest House', StayType.guestHouse, 'Bahria Town',
    'Phase 4, Bahria Town, Islamabad', 6500, 4.5, 99,
    desc: 'Modern guest house in a gated community with 24/7 security.',
    amenities: ['Wi-Fi', 'AC', 'Parking', 'Generator Backup', 'Lounge'],
    food: 4.4,
    foodInfo: 'Restaurant inside community, free breakfast.',
    meals: true,
    perks: ['Gated security', 'Free breakfast'],
    offer: '12% off for stays of 5+ nights',
    nearby: 'Bahria Town food street - 5 min',
  ),
  _stay(
    12, 'Airport Transit Lodge', StayType.guestHouse, 'Airport Road',
    'Airport Road, Islamabad', 3800, 3.9, 64,
    desc: 'Convenient for early flights and late arrivals.',
    amenities: ['Wi-Fi', 'AC', 'Parking', '24/7 Reception'],
    food: 3.7,
    foodInfo: 'Light breakfast and snacks available.',
    perks: ['Free airport pickup', '24/7 reception'],
    nearby: 'Airport - 10 min',
  ),
];
