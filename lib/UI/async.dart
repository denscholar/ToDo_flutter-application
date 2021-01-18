import 'package:flutter/material.dart';

class AsyncScreen extends StatelessWidget {
  void call() {
    print('method 1');
    print('method 2');
    method3();
    print('method 4');
    print('method 5');
  }

  void method3() async {
    await Future.delayed(
        Duration(
          seconds: 1,
        ),
        () {});
    print('Method 3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Async'),
      ),
      body: Container(
          child: Center(
        child: RaisedButton(
            color: Colors.blue,
            child: Text(
              'Add',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              call();
            }),
      )),
    );
  }
}
