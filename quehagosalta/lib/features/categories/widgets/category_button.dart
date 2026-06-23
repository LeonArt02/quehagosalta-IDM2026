import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryButton({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
    this.isSelected = false,
  });

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        elevation: isSelected ? 4 : 2,
        backgroundColor: isSelected ? Colors.amber.shade100 : Colors.white,
        avatar: Icon(
          icon,
          color: isSelected ? Colors.orange.shade800 : Colors.amber.shade700,
          size: 18,
        ),
        label: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.black : Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onTap,
      ),
    );
  }
}
