import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/model/jobsheet.dart';
import 'package:safmobile_portal/services/search_firestore.dart';

class SearchProvider extends ChangeNotifier {
  final SearchFirestore _searchFirestore = SearchFirestore();

  List<dynamic> _searchResult = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<dynamic> get searchResult => _searchResult;

  Future<void> searchReference(String ticketId) async {
    _isLoading = true;
    notifyListeners();
    _searchResult = await _searchFirestore.searchDocuments(ticketId);

    //sort the result by date
    _searchResult.sort((a, b) {
      Timestamp timeA = (a is Invoice) ? a.lastUpdate : (a as Jobsheet).pickupDate;
      Timestamp timeB = (b is Invoice) ? b.lastUpdate : (b as Jobsheet).pickupDate;
      return timeB.compareTo(timeA);
    });
    _isLoading = false;
    notifyListeners();
  }
}
