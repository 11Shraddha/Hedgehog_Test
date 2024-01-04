import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final bool isLoading;

  const AppLoader({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
      ],
    );
  }
}
