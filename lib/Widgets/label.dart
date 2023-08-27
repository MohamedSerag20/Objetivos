import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Label extends StatelessWidget {
  const Label({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.background.withOpacity(0.66),
            Theme.of(context).colorScheme.background.withOpacity(0.44),
            Theme.of(context).colorScheme.background.withOpacity(0.22),
          ])),
      child: Text(value,style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
