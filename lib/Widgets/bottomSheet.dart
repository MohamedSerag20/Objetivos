import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Widgets/label.dart';
import 'package:my_duties/Models/item.dart';
import 'package:my_duties/Providers/listsProvider.dart';
import 'package:my_duties/Screens/final.dart';
import 'package:my_duties/Providers/listsProvider.dart';
import 'package:http/http.dart' as http;
import '../Models/item.dart';

class BottomSheete extends ConsumerWidget {
  const BottomSheete({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Label(value: item.name),
        const SizedBox(
          height: 30,
        ),
        const Label(value: "Details"),
        const SizedBox(
          height: 4,
        ),
        Center(
          child: Text(
            item.details,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.background)),
            onPressed: () async {
              if (ref.read(fDutiesProvider).contains(item)) {
                final urlDuties = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Duties/${item.id}.json');
                final response = await http.delete(urlDuties);
                ref.read(fDutiesProvider.notifier).removeItem(item);
              } else if (ref.read(fOrdersProvider).contains(item)) {
                final urlOrders = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Orders/${item.id}.json');
                final response = await http.delete(urlOrders);
                ref.read(fOrdersProvider.notifier).removeItem(item);
              } else if (ref.read(fScohoolProvider).contains(item)) {
                final urlWork = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Work/${item.id}.json');
                final response = await http.delete(urlWork);
                ref.read(fScohoolProvider.notifier).removeItem(item);
              } else if (ref.read(fSDevProvider).contains(item)) {
                final urlSDev = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-SDev/${item.id}.json');
                final response = await http.delete(urlSDev);
                ref.read(fSDevProvider.notifier).removeItem(item);
              } else if (ref.read(fZakerProvider).contains(item)) {
                final urlZaker = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Zaker/${item.id}.json');
                final response = await http.delete(urlZaker);
                ref.read(fZakerProvider.notifier).removeItem(item);
              } else if (ref.read(fDuaaProvider).contains(item)) {
                final urlDuaa = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Duaa/${item.id}.json');
                final response = await http.delete(urlDuaa);
                ref.read(fDuaaProvider.notifier).removeItem(item);
              } else if (ref.read(fGameProvider).contains(item)) {
                final urlGame = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Game/${item.id}.json');
                final response = await http.delete(urlGame);
                ref.read(fGameProvider.notifier).removeItem(item);
              } else if (ref.read(fSportProvider).contains(item)) {
                final urlSport = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Sport/${item.id}.json');
                final response = await http.delete(urlSport);
                ref.read(fSportProvider.notifier).removeItem(item);
              } else if (ref.read(fAnotherProvider).contains(item)) {
                final urlAnother = Uri.https(
                    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'My-Home-Another/${item.id}.json');
                final response = await http.delete(urlAnother);
                ref.read(fAnotherProvider.notifier).removeItem(item);
              }
              Navigator.of(context).pop();
            },
            child: const Text("I Finished"))
      ],
    );
  }
}
