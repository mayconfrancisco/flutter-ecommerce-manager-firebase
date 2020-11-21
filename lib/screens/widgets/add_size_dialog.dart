import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(_textController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
