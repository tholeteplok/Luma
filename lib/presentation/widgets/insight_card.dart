import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';

/// Insight Card widget dengan severity-based styling
/// Menampilkan insight dengan tone yang grounded (NVC-aligned)
class InsightCard extends StatelessWidget {
  final String id;
  final String title;
  final String message;
  final String severity;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const InsightCard({
    super.key,
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
    this.onTap,
    this.onDismiss,
  });

  Color _getSeverityColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return AppColors.critical;
      case 'notice':
        return AppColors.warning;
      case 'gentle':
      case 'positive':
        return AppColors.positive;
      case 'info':
      default:
        return AppColors.info;
    }
  }

  IconData _getSeverityIcon() {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'notice':
        return Icons.info_outline;
      case 'gentle':
      case 'positive':
        return Icons.self_improvement;
      case 'info':
      default:
        return Icons.lightbulb_outline;
    }
  }

  String _getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor();
    final severityIcon = _getSeverityIcon();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isRead ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead ? AppColors.borderDark.withOpacity(0.3) : severityColor.withOpacity(0.3),
          width: isRead ? 1 : 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isRead
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      severityColor.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan icon dan timestamp
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      severityIcon,
                      size: 20,
                      color: severityColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isRead
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textDarkPrimary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getRelativeTime(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textDarkSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (!isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: severityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDarkSecondary,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 12),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onDismiss != null)
                    TextButton.icon(
                      onPressed: onDismiss,
                      icon: const Icon(Icons.close, size: 16),
                      label: Text(
                        'Sembunyikan',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textDarkSecondary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
