import 'package:flutter/material.dart';

import 'package:flutter_firebase_ddd_notes/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;

  const CriticalFailureDisplay({
    Key key,
    this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '😱',
            style: TextStyle(fontSize: 100),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            failure.maybeMap(
                insufficientPermission: (_) => 'Insufficient Permissions',
                orElse: () => 'Unexpected Error.\nPlease contact support'),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            onPressed: () {
              print('Sending email!');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.mail),
                SizedBox(
                  width: 4,
                ),
                Text('I NEED HELP'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
