import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:stock_quotes/models/quotes.dart';
import 'package:stock_quotes/services/api_service.dart';
import 'package:stock_quotes/services/storage_service.dart';

class HomeScreenController extends GetxController {
  //var _apiService = Get.put(ApiService());
  //var _storageService = Get.put(StorageService());
  var _apiService = Get.find<ApiService>();
  var _storageService = Get.find<StorageService>();

  //List<String> _quotes = ['VOO', 'GAA', 'GLD', 'W'];
  List<String> get _quotes => _storageService.quotes;
  List<Quote> get results => _apiService.results;

  TextEditingController myTextController = TextEditingController();
  RefreshController refreshController = RefreshController(initialRefresh: true);

  //Statuses
  var isAddQuoteRequested = false;
  var isRemoveQuoteRequested = false;

  void refreshData() {
    refreshController.requestRefresh();
  }

  void fetchData() async {
    if (_quotes.isEmpty) await _storageService.loadData();
    print('Fetching data for: ${_quotes.toString()}');
    await _apiService.fetchAll(_quotes);
    print('Results from apiService: ${_apiService.results.toString()}');

    refreshController.refreshCompleted();
    update();
  }

  void requestAddQuote() {
    isAddQuoteRequested = !isAddQuoteRequested;
    update();
  }

  void requestRemoveQuote() {
    isRemoveQuoteRequested = !isRemoveQuoteRequested;
    update();
  }

  void addQuoteToList(String quote) {
    if (quote.length > 0 && !_quotes.contains(quote)) {
      _quotes.add(quote);
      _storageService.saveData();
      isAddQuoteRequested = false;
      update(); // To close adding quotes UI
      refreshData(); // To fetch new data
    }
  }

  void deleteQuoteFromList(Quote quote) {
    print('Delete: ${quote.quote}');
    _quotes.remove(quote.quote);
    _storageService.saveData();
    results.remove(quote);
    update();
    //saveQuotes();
  }

  void addButtonClicked() {
    if (myTextController.isBlank != null)
      addQuoteToList(myTextController.text.toString());
    myTextController.text = "";
  }
}

/* 
  void editData() {
    view.setState(() {
      editing = !editing;
    });
  }

  void delete(Quote quote) {
    view.setState(() {
      print('Delete: ${quote.quote}');
      quotes.remove(quote.quote);
      results.remove(quote);
      saveQuotes();
    });
  }

  void addData() {
    view.setState(() {
      adding = !adding;
    });
  }

  void addQuote(String quote) {
    if (quote.length > 0) {
      quotes.add(quote);
      saveQuotes();
      updateData();
    }
  }

  void loadQuotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    quotes = prefs.getStringList('quotes') ?? ['gaa', 'voo', 'gld'];
    updateData();
  }

  void saveQuotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var success = await prefs.setStringList('quotes', quotes);
    print('Saving to disk success: $success');
  } */
