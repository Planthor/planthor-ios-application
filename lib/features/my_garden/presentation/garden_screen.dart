import 'package:flutter/material.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key, this.claims});

  final Map<String, dynamic>? claims;

  @override
  Widget build(BuildContext context) {
    if (claims == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final rows = <_ClaimRow>[
      if (claims!['name'] != null)
        _ClaimRow('Name', claims!['name'].toString()),
      if (claims!['preferred_username'] != null)
        _ClaimRow('Username', claims!['preferred_username'].toString()),
      if (claims!['email'] != null)
        _ClaimRow('Email', claims!['email'].toString()),
      if (claims!['sub'] != null)
        _ClaimRow('Subject (sub)', claims!['sub'].toString()),
      if (claims!['given_name'] != null)
        _ClaimRow('First Name', claims!['given_name'].toString()),
      if (claims!['family_name'] != null)
        _ClaimRow('Last Name', claims!['family_name'].toString()),
      if (claims!['exp'] != null)
        _ClaimRow(
          'Token Expires',
          DateTime.fromMillisecondsSinceEpoch(
            (claims!['exp'] as int) * 1000,
          ).toLocal().toString(),
        ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Session Info',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.earthBrown,
            ),
          ),
        ),
        if (rows.isEmpty)
          const Text(
            'No claims decoded from token.',
            style: TextStyle(color: AppColors.textGrey),
          )
        else
          ...rows.map(
            (r) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        r.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        r.value,
                        style: const TextStyle(
                          color: AppColors.earthBrown,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ClaimRow {
  const _ClaimRow(this.label, this.value);
  final String label;
  final String value;
}
