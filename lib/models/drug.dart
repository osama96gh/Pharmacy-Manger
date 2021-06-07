import 'dart:math';

import 'package:pharmacy_manager/utilities/enums.dart';

class Drug {
  String? id;
  String serial;
  String name;
  String? description;
  int expiredAt;

  Drug({
    this.id,
    required this.serial,
    required this.name,
    required this.expiredAt,
    this.description,
  });

  get remainDaysToExpired {
    return max(
        DateTime.fromMillisecondsSinceEpoch(expiredAt)
            .difference(DateTime.now())
            .inDays,
        0);
  }

  get drugState {
    int r = remainDaysToExpired;
    if (r <= 0) return DrugState.expired;

    if (r < 30) return DrugState.shortExpired;

    return DrugState.longExpired;
  }
}
