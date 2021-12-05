import 'package:flutter/material.dart';
import 'package:guitar_chords_web/src/components/components.dart';

class DisplayItem extends StatelessWidget {
  const DisplayItem({
    Key? key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 20,
                  )
                : const SizedBox.shrink(),
            Text(
              title,
              style: bodyTextStyle,
            ),
            Icon(
              icon,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}