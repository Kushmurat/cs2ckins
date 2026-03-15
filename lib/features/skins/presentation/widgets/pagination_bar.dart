import 'dart:math';
import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final pageNumbers = _buildPageNumbers();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: const Border(
          top: BorderSide(color: Color(0xFF2A2A4A), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous
          _PaginationButton(
            icon: Icons.chevron_left,
            enabled: currentPage > 1,
            onTap: () => onPageSelected(currentPage - 1),
          ),
          const SizedBox(width: 4),

          // Page numbers
          ...pageNumbers.map((item) {
            if (item == -1) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '...',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _PageNumber(
                number: item,
                isActive: item == currentPage,
                onTap: () => onPageSelected(item),
              ),
            );
          }),

          const SizedBox(width: 4),
          // Next
          _PaginationButton(
            icon: Icons.chevron_right,
            enabled: currentPage < totalPages,
            onTap: () => onPageSelected(currentPage + 1),
          ),
        ],
      ),
    );
  }

  /// Builds page number list with ellipsis, e.g.: 1 ... 4 5 [6] 7 8 ... 50
  List<int> _buildPageNumbers() {
    if (totalPages <= 7) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final pages = <int>{};
    // Always show first and last
    pages.add(1);
    pages.add(totalPages);

    // Show window around current page
    final windowStart = max(2, currentPage - 1);
    final windowEnd = min(totalPages - 1, currentPage + 1);
    for (int i = windowStart; i <= windowEnd; i++) {
      pages.add(i);
    }

    final sorted = pages.toList()..sort();

    // Insert -1 for ellipsis gaps
    final result = <int>[];
    for (int i = 0; i < sorted.length; i++) {
      if (i > 0 && sorted[i] - sorted[i - 1] > 1) {
        result.add(-1); // ellipsis
      }
      result.add(sorted[i]);
    }
    return result;
  }
}

class _PageNumber extends StatelessWidget {
  final int number;
  final bool isActive;
  final VoidCallback onTap;

  const _PageNumber({
    required this.number,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? null : onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE94560) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$number',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PaginationButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF0F3460)
              : const Color(0xFF0F3460).withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey[700],
          size: 20,
        ),
      ),
    );
  }
}
