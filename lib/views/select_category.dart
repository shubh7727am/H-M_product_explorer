import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hm_productexplorer/view_models/tagCodes_notifier.dart';
import '../models/category.dart';
import '../view_models/category_notifier.dart';

class SelectCategory extends ConsumerStatefulWidget {
  const SelectCategory({super.key});

  @override
  SelectCategoryState createState() => SelectCategoryState();
}

class SelectCategoryState extends ConsumerState<SelectCategory> {
  // Selected category
  Cate? selectedCategory;


  @override
  Widget build(BuildContext context) {
    // Listen to the category state
    final categoriesState = ref.watch(cateGoryNotifierProvider);
    final selectedCodesState = ref.watch(selectedCateProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: categoriesState.when(
        data: (categories) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown to select a category
              DropdownButton<Cate>(
                value: selectedCategory,
                items: [
                  DropdownMenuItem<Cate>(
                    value: null, // Use `null` or another `Cate` object representing "All"
                    child: const Text('All'),
                    onTap: (){

                    },
                  ),
                  ...categories.map((category) {
                    return DropdownMenuItem<Cate>(
                      value: category,
                      child: Text(category.catName ?? 'Unnamed Category'),
                    );
                  }),
                ],
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),

              const SizedBox(height: 20),
              // Display subcategories of the selected category
              if (selectedCategory != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedCategory!.catSublist!.length + 1,
                    itemBuilder: (context, index) {



                      if(index == selectedCategory!.catSublist!.length){
                        return ListTile(
                          title: const Text('All',
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),

                          onTap: () {
                            // Handle subcategory selection
                          }
                        );
                      }

                      else{

                        final subCategory = selectedCategory!.catSublist![index];
                        final hasTagCodes = subCategory.tagCodes?.isNotEmpty ?? false;
                        return ListTile(
                          title: Text(
                            subCategory.catName ?? 'Unnamed Subcategory',
                            style: hasTagCodes
                                ? null
                                : const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: hasTagCodes
                              ? const Icon(Icons.chevron_right)
                              : const Icon(Icons.block, color: Colors.grey),
                          onTap: hasTagCodes
                              ? () {
                            // Handle subcategory selection

                            ref.read(selectedCateProvider.notifier).clearTagCodes();
                            var tags = subCategory.tagCodes;
                            if (tags != null && tags.isNotEmpty) {
                              for (int i = 0; i < tags.length; i++) {
                                var tag = tags[i];
                                ref.read(selectedCateProvider.notifier).addTagCode(tag);
                                // Your code to process each tag goes here
                              }
                            }






                          }
                              : null, // Disable tapping for subcategories with no tag codes
                        );

                      }


                    },
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}
