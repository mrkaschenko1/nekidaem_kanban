// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

enum CardRow { OnHold, InProgress, NeedsReview, Approved }

extension CardRowExtension on CardRow {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case CardRow.OnHold:
        return 'On hold';
      case CardRow.InProgress:
        return 'In Progress';
      case CardRow.NeedsReview:
        return 'Needs Review';
      case CardRow.Approved:
        return 'Approved';
      default:
        return 'Unknown';
    }
  }
}
