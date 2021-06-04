import 'package:flutter/material.dart';
import 'package:pharmacy_manager/app_state.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => App(),
  ));
}
