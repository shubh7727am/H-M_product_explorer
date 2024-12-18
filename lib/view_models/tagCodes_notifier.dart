import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/selected_category.dart';
import 'category_notifier.dart'; // Import the CategoryNotifier

class SelectedCateNotifier extends StateNotifier<SelectedCate> {
  final CategoryNotifier _categoryNotifier;

  SelectedCateNotifier(this._categoryNotifier) : super(SelectedCate(tagCodes: [],name: ""));

  // Method to add a tag code
  void addTagCode(String tagCode,String cateName) {
    state.tagCodes.add(tagCode);
    // Notify listeners about the change
    state = SelectedCate(tagCodes: List.from(state.tagCodes),name: cateName);

    // Fetch categories if not already fetched
    if (!_categoryNotifier.state.hasValue) {
      _categoryNotifier.fetchCategories();
    }
  }



  // Method to remove a tag code
  void removeTagCode(String tagCode,String cateName) {
    state.tagCodes.remove(tagCode);
    // Notify listeners about the change
    state = SelectedCate(tagCodes: List.from(state.tagCodes),name: cateName);
  }

  // Method to clear all tag codes
  void clearTagCodes() {
    state.tagCodes.clear();
    // Notify listeners about the change
    state = SelectedCate(tagCodes: [] , name: "");
  }

  // Initialize tag codes when categories are fetched
  Future<void> initializeTagCodes() async {
    await _categoryNotifier.fetchCategories(); // Ensure categories are fetched
    final allTagCodes = _categoryNotifier.getAllTagCodes();
    state = SelectedCate(tagCodes: allTagCodes , name: "All");
  }
}

// Create a provider for SelectedCateNotifier
final selectedCateProvider = StateNotifierProvider<SelectedCateNotifier, SelectedCate>((ref) {
  final categoryNotifier = ref.read(cateGoryNotifierProvider.notifier); // Read the CategoryNotifier
  return SelectedCateNotifier(categoryNotifier);
});


