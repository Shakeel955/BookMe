import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/stay_repository.dart';

// TEMPORARY details screen: proves routing + data lookup by id works.
// The full design (carousel, amenities, food, reviews) comes next.
class StayDetailsScreen extends ConsumerWidget {
  final String stayId;
  const StayDetailsScreen({super.key, required this.stayId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stayAsync = ref.watch(stayByIdProvider(stayId));

    return Scaffold(
      appBar: AppBar(),
      body: stayAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (stay) {
          if (stay == null) return const Center(child: Text('Stay not found'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(stay.images.first,
                    height: 220, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text(stay.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(stay.address,
                  style: const TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 12),
              Text('Rs ${stay.pricePerNight} / night',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
              const SizedBox(height: 12),
              Text(stay.description),
            ],
          );
        },
      ),
    );
  }
}
