import 'package:flutter/material.dart';

class LevelJourneyPage extends StatelessWidget {
  const LevelJourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const JourneyHeader(),
            Text("kosong dulu")
            // const SizedBox(height: 16),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20),
            //       child: Stack(
            //         alignment: Alignment.center,
            //         children: [
            //           CustomPaint(
            //             size: const Size(double.infinity, 800),
            //             painter: _JourneyPathPainter(),
            //           ),
            //           Column(
            //             children: [
            //               const SizedBox(height: 40),
            //               Align(
            //                 alignment: Alignment.centerRight,
            //                 child: Column(
            //                   children: [
            //                     Image.asset(
            //                       "assets/images/dino_soccer.png",
            //                       height: 100,
            //                     ),
            //                     _levelBlock(isActive: true),
            //                   ],
            //                 ),
            //               ),
            //               const SizedBox(height: 120),
            //               Align(
            //                 alignment: Alignment.centerLeft,
            //                 child: Column(
            //                   children: [
            //                     Image.asset(
            //                       "assets/images/dino_book.png",
            //                       height: 100,
            //                     ),
            //                     _levelBlock(),
            //                   ],
            //                 ),
            //               ),
            //               const SizedBox(height: 120),
            //               Align(
            //                 alignment: Alignment.centerRight,
            //                 child: Column(
            //                   children: [
            //                     Image.asset(
            //                       "assets/images/dino_daily_mission.png",
            //                       height: 100,
            //                     ),
            //                     _levelBlock(),
            //                   ],
            //                 ),
            //               ),
            //               const SizedBox(height: 150),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _levelBlock({bool isActive = false}) {
    return Container(
      width: 70,
      height: 20,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4A90E2) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class JourneyHeader extends StatelessWidget {
  const JourneyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          Row(
            children: const [
              Icon(Icons.local_fire_department, color: Colors.grey, size: 22),
              SizedBox(width: 4),
              Text(
                "4",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.ac_unit, color: Colors.lightBlueAccent, size: 22),
              SizedBox(width: 4),
              Text(
                "200",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Text(
            "XP 520",
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.1, 50);
    path.lineTo(size.width * 0.9, 150);
    path.lineTo(size.width * 0.1, 300);
    path.lineTo(size.width * 0.9, 450);
    path.lineTo(size.width * 0.1, 600);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
