import 'package:flutter/material.dart';
import 'package:stock_quotes/screens/home_screen_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  //HomeScreen({Key key}) : super(key: key);

  final controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Quotes'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: controller.requestRemoveQuote,
          ),
        ],
      ),
      body: GetBuilder<HomeScreenController>(
          builder: (_) => SmartRefresher(
              controller: controller.refreshController,
              onRefresh: controller.fetchData,
              child: ListView.separated(
                itemCount: controller.results.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.results[index].quote.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(controller.results[index].name),
                    leading: Text(controller.results[index].change,
                        style: TextStyle(
                          color:
                              controller.results[index].change.startsWith('-')
                                  ? Colors.red
                                  : Colors.blue,
                        )),
                    trailing: controller.isRemoveQuoteRequested
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              controller.deleteQuoteFromList(
                                  controller.results[index]);
                            },
                            //controller.delete(controller.results[index]),
                          )
                        : Text(controller.results[index].value),
                  );
                },
              ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.bottomSheet(
            Center(
              child: Column(children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(left: 50, top: 50, right: 50, bottom: 10),
                  width: double.maxFinite,
                  //height: 50,
                  child: TextField(
                    controller: controller.myTextController,
                    onSubmitted: (text) {
                      controller.addQuoteToList(text);
                      Get.back();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quote',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  width: double.maxFinite,
                  height: 50,
                  child: RaisedButton(
                      child: Text('Add Quote'),
                      textColor: Colors.white,
                      elevation: 4.0,
                      color: Colors.blueAccent,
                      onPressed: () {
                        // if (controller.myTextController.isBlank != null)
                        //   controller.addQuoteToList(
                        //       controller.myTextController.text.toString());
                        // controller.myTextController.text = "";
                        controller.addButtonClicked();
                        Get.back();
                      }),
                ),
              ]),
            ),
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }
}
