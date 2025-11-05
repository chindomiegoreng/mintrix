import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

class NoteCard extends StatelessWidget {
  final String date;
  final String content;

  const NoteCard({
    super.key,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage('assets/images/notes_card.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Text(
            date,
            style:  TextStyle(
              color: bluePrimaryColor, 
              fontWeight: FontWeight.w400,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 7,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff6C6C6C), 
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}