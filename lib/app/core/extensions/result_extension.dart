import 'package:flutter/material.dart';
import 'package:learn_getx2/app/core/results/result.dart';

import '../dialogs/app_dialog.dart';

extension ResultDialogExtension<T> on Result<T> {
  Future<bool> showErrorDialog() async {
    switch (this) {
      case Success<T>():
        return true;

      case Failure<T>():
        final failure = this as Failure<T>;
        AppDialog.error(failure.message);
        return false;
    }
  }

  // Show API error with code
  Future<bool> showApiErrorDialog() async {
    switch (this) {
      case Success<T>():
        return true;

      case Failure<T>():
        final failure = this as Failure<T>;
        AppDialog.apiError(
          code: failure.code,
          error: failure.message,
          message: failure.message,
        );
        return false;
    }
  }
}
