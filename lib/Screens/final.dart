import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Models/item.dart';
import 'package:my_duties/Providers/listsProvider.dart';
import 'package:my_duties/Widgets/bottomSheet.dart';

class Missions_in_Order extends ConsumerWidget {
  const Missions_in_Order({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(allListProvider);
    print("done");
    // final items = ref.watch(fDutiesProvider) +
    //     ref.watch(fOrdersProvider) +
    //     ref.watch(fScohoolProvider) +
    //     ref.watch(fSDevProvider) +
    //     ref.watch(fZakerProvider) +
    //     ref.watch(fDuaaProvider) +
    //     ref.watch(fGameProvider) +
    //     ref.watch(fSportProvider) +
    //     ref.watch(fAnotherProvider);

    final List<Item> orderedList = [];

    for (final item
        in items.where((element) => element.priority == "Urgent")) {
      orderedList.add(item);
    }
    for (final item
        in items.where((element) => element.priority == "Imporant")) {
      orderedList.add(item);
    }
    for (final item
        in items.where((element) => element.priority == "Medium")) {
      orderedList.add(item);
    }
    for (final item
        in items.where((element) => element.priority == "Regular")) {
      orderedList.add(item);
    }

    return ListView(
      children: [
        for (final item in orderedList)
          InkWell(
            onTap: () {
              showBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return BottomSheete(item: item);
                  });
            },
            child: Container(
              decoration: const BoxDecoration(),
              height: 40,
              margin: const EdgeInsets.all(8),
              child: Card(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Text(
                    '${item.name} (${item.priority})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
