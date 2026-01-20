import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumGlassNavbar extends StatelessWidget {
  final int currentIndex;
  final List<NavItem> items;
  final Function(int) onTap;

  const PremiumGlassNavbar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark ? [
                  const Color(0xFF2A3A4A).withValues(alpha: 0.15),
                  const Color(0xFF1A2A3A).withValues(alpha: 0.2),
                ] : [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.white.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                return _buildNavItem(index);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = currentIndex == index;
    final item = items[index];

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 56,
        height: 56,
        decoration: isSelected
            ? BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4A5A6A).withValues(alpha: 0.5), // Brighter top shine
                    const Color(0xFF2A3A4A).withValues(alpha: 0.7), // Mid tone
                    const Color(0xFF0A1A2A).withValues(alpha: 0.9), // Deeper bottom shadow
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  // Strong top highlight (outer)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                    spreadRadius: -1,
                  ),
                  // Inner top shine
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, -1),
                    spreadRadius: -3,
                  ),
                  // Strong bottom shadow (outer)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                    spreadRadius: -1,
                  ),
                  // Inner bottom shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                    spreadRadius: -3,
                  ),
                ],
              )
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Strong glossy top shine overlay
            if (isSelected)
              Positioned(
                top: 0,
                child: Container(
                  width: 56,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.0,
                      colors: [
                        Colors.white.withValues(alpha: 0.4), // Strong center shine
                        Colors.white.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            // Bottom shadow overlay
            if (isSelected)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 56,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.bottomCenter,
                      radius: 1.0,
                      colors: [
                        Colors.black.withValues(alpha: 0.4), // Strong center shadow
                        Colors.black.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            Icon(
              item.icon,
              color: isSelected ? const Color(0xFFFFD700) : Colors.white.withValues(alpha: 0.5), // Yellow when active
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}