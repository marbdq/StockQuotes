import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:stock_quotes/models/quotes.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  List<Quote> results = [];

  Future<List<Quote>> fetchAll(List<String> quotes) async {
    var requests =
        List<Future<Quote>>.empty(growable: true); // = List<Future<Quote>>();
    for (var quote in quotes) {
      requests.add(fetchData(quote));
    }
    results = await Future.wait(requests);

    //print('> Results: $results');

    results.sort((q1, q2) => double.parse(q2.change.replaceAll('%', ''))
        .compareTo(double.parse(q1.change.replaceAll('%', ''))));

    return results;
  }

  Future<Quote> fetchData(String quote) async {
    String value;
    String name;
    String change;

    try {
      var url = Uri.parse("https://finviz.com/quote.ashx?t=" + quote);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var document = parse(response.body);
        // Value and Change
        var elements = document.getElementsByClassName("snapshot-td2");
        value = elements.elementAt(65).text;
        change = elements.elementAt(71).text;
        // Name
        elements = document.getElementsByClassName("fullview-title");
        name = elements.elementAt(0).getElementsByTagName('tr')[1].text;

        print('title: ' +
            elements.elementAt(0).getElementsByTagName('tr')[1].text);
        //name = elements.elementAt(65).text;
        return Quote(name: name, quote: quote, value: value, change: change);
      } else {
        // Not found
        return Quote(
            name: 'Not found', quote: quote, value: '0.0', change: '0.0');
      }
    } on Exception catch (e) {
      // Issue while loading data
      Get.snackbar('Error loading $quote', e.toString());
      return Quote(name: 'Error', quote: quote, value: '0.0', change: '0.0');
    }
  }
}
