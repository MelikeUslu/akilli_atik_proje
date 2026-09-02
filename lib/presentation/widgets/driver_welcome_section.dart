import 'package:flutter/material.dart';

final class DriverWelcomeSection extends StatelessWidget {
  const DriverWelcomeSection({super.key, required this.fullName});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = fullName.trim().isEmpty ? 'Şoför' : fullName.trim();

    return Semantics(
      header: true,
      label: 'Hoş geldin $displayName',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.person_rounded, size: 88, color: Color(0xFF263238)),
                Positioned(
                  right: 18,
                  bottom: 22,
                  child: Icon(
                    Icons.eco_rounded,
                    size: 52,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hoş Geldin,',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
