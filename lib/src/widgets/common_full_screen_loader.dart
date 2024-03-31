import 'package:flutter/material.dart';
import 'package:my_mvvm_app/src/widgets/common_loader.dart';

class CommonFullScreenLoader extends StatelessWidget {
  const CommonFullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: const Center(
        child: CommonLoader(),
      ),
    );
  }
}
