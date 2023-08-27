import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final urlDuties = Uri.https(
    'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
    'My-Home-Duties.json');

class HomeProvider extends StateNotifier<List<Item>> {
  HomeProvider() : super([]);

  void addItem(Item itemW) {
    state = [...state, itemW];
  }

  void removeItem(Item itemW) {
    state = state.where((m) {
      print(m.id);
      return m.id != itemW.id;
    }).toList();
  }

  void backUp() async {
    final response = await http.get(urlDuties);
    Map<String, dynamic> loadedList = json.decode(response.body);
  }
}

final fDutiesProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fOrdersProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fScohoolProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fSDevProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fZakerProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fDuaaProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fGameProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fSportProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});
final fAnotherProvider = StateNotifierProvider<HomeProvider, List<Item>>((ref) {
  return HomeProvider();
});

final allListProvider = Provider((ref) =>
    ref.watch(fDutiesProvider) +
    ref.watch(fOrdersProvider) +
    ref.watch(fScohoolProvider) +
    ref.watch(fSDevProvider) +
    ref.watch(fZakerProvider) +
    ref.watch(fDuaaProvider) +
    ref.watch(fGameProvider) +
    ref.watch(fSportProvider) +
    ref.watch(fAnotherProvider));
