
import '../results/result.dart';
import '../dialogs/app_dialog.dart';

extension ResultDialogExtension<T> on Result<T> {
  Future<bool> showErrorDialog() async {
    switch (this) {
      case Success<T>():
        return true;

      case Failure<T>():
        final failure = this as Failure<T>;
        AppDialog.error(message: failure.message);
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
        AppDialog.error(
          message: failure.message,
          title: 'Oops',
          buttonText: 'Okay',
        );
        return false;
    }
  }

  // Get error message
  String? get errorMessage {
    switch (this) {
      case Success<T>():
        return null;
      case Failure<T>():
        final failure = this as Failure<T>;
        return failure.message;
    }
  }

  // Check if failure has code
  int? get errorCode {
    switch (this) {
      case Success<T>():
        return null;
      case Failure<T>():
        final failure = this as Failure<T>;
        return failure.code;
    }
  }
}