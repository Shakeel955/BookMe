import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/stay.dart';
import '../../data/repositories/stay_repository.dart';

// TEMPORARY home screen: only to verify setup, theme, routing, and data.
// We will replace this with the real Home design in the next step.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staysAsync = ref.watch(staysProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BookMe',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
      body: staysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
        data: (stays) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: stays.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _StayTile(stay: stays[i]),
        ),
      ),
    );
  }
}

class _StayTile extends StatelessWidget {
  final Stay stay;
  const _StayTile({required this.stay});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(AppRoutes.stayDetailsPath(stay.id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                stay.images.first,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: AppColors.border,
                  child: const Icon(Icons.hotel, color: AppColors.textGrey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stay.type.label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      stay.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${stay.area}, ${stay.city}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: AppColors.secondary),
                        const SizedBox(width: 2),
                        Text(stay.rating.toString(),
                            style: const TextStyle(fontSize: 12)),
                        const Spacer(),
                        Text(
                          'Rs ${stay.pricePerNight}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(' /night',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textGrey)),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
