import 'package:flutter_bloc/flutter_bloc.dart';

class CheckboxCubit<T> extends Cubit<List<T>> {
  CheckboxCubit() : super([]);

  /// Initializes the checkbox state with the provided selected items.
  void initialize(List<T> selectedItems) {
    emit(selectedItems.isNotEmpty ? selectedItems : []);
  }

  void toggleSelection(T item) {
    final currentState = List<T>.from(state); // Copy current state
    if (currentState.contains(item)) {
      currentState.remove(item); // Remove if already selected
    } else {
      currentState.add(item); // Add if not selected
    }
    emit(currentState); // Emit the new state
  }

  /// Clears all selections.
  void clearSelections() {
    emit([]); // Emit an empty list to clear selections
  }
}
