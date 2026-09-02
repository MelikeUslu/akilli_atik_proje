import 'package:flutter/material.dart';

final class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final statusColor = isOnline
        ? const Color(0xFF1B5E20)
        : Theme.of(context).colorScheme.error;

    return Semantics(
      label: isOnline
          ? 'Bağlantı durumu çevrimiçi'
          : 'Bağlantı durumu çevrimdışı',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              color: statusColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bağlantı Durumu',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  isOnline ? 'Çevrimiçi' : 'Çevrimdışı',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
