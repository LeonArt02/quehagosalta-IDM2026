import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String name;
  final IconData icon;
  //final VoidCallBack onTap;

  const CategoryButton({
    super.key,
    required this.name,
    required this.icon,
    // required this.onTap,
  });

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        elevation: 2,
        backgroundColor: Colors.white,
        avatar: Icon(icon, color: Colors.amber.shade700, size: 18),
        label: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //  onPressed: onTap,
      ),
    );
  }
}
