import 'package:flutter/material.dart';
import 'package:my_duties/Models/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Providers/listsProvider.dart';

class ItemWidget extends StatelessWidget {
  ItemWidget({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        subtitle: Text(
          item.details,
          softWrap: true,
          maxLines: 1,
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        title: Text(
          textAlign: TextAlign.start,
          item.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            item.priority,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
    );
  }
}
