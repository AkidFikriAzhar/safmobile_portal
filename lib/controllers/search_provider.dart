import 'package:flutter/material.dart';
import 'package:safmobile_portal/model/search_result.dart';
import 'package:safmobile_portal/services/search_firestore.dart';

class SearchProvider extends ChangeNotifier {
  final SearchFirestore _searchFirestore;

  SearchProvider(this._searchFirestore);

  List<SearchResult> _results = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<SearchResult> get results => _results;

  Future<void> searchReference(String ticketId) async {
    _isLoading = true;
    notifyListeners();
    _results = await _searchFirestore.searchByReference(int.parse(ticketId));

    // //sort the result by date
    // _results.sort((a, b) {
    //   Timestamp timeA = (a is Invoice) ? a.lastUpdate : (a as Jobsheet).pickupDate;
    //   Timestamp timeB = (b is Invoice) ? b.lastUpdate : (b as Jobsheet).pickupDate;
    //   return timeB.compareTo(timeA);
    // });
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _results = [];
    _isLoading = true;
    notifyListeners();
  }
}
