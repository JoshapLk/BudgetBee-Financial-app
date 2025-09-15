import 'package:flutter/material.dart';

class BeeLogo extends StatelessWidget {
  final double size;
  
  const BeeLogo({super.key, this.size = 80.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFD700), // Yellow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bee wings
          Positioned(
            top: -size * 0.15,
            child: Container(
              width: size * 0.8,
              height: size * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.2),
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          // Wallet icon
          Icon(
            Icons.account_balance_wallet,
            size: size * 0.5,
            color: Colors.black,
          ),
          // Bee stripes
          Positioned(
            top: size * 0.2,
            child: Container(
              width: size * 0.6,
              height: 2,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: size * 0.4,
            child: Container(
              width: size * 0.6,
              height: 2,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
