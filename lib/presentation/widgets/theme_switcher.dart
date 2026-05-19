import 'package:flutter/material.dart';
import '../../core/themes/colors.dart';

/// Theme Switcher widget untuk toggle dark/light mode
class ThemeSwitcher extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  const ThemeSwitcher({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeButton(
            icon: Icons.brightness_auto,
            label: 'Auto',
            isSelected: currentThemeMode == ThemeMode.system,
            onTap: () => onThemeChanged(ThemeMode.system),
          ),
          _ThemeButton(
            icon: Icons.brightness_2,
            label: 'Dark',
            isSelected: currentThemeMode == ThemeMode.dark,
            onTap: () => onThemeChanged(ThemeMode.dark),
          ),
          _ThemeButton(
            icon: Icons.brightness_high,
            label: 'Light',
            isSelected: currentThemeMode == ThemeMode.light,
            onTap: () => onThemeChanged(ThemeMode.light),
          ),
        ],
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textDarkSecondary,
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textDarkSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
