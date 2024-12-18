import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hm_productexplorer/view_models/product_notifier.dart';
import 'package:hm_productexplorer/view_models/tagCodes_notifier.dart';
import 'package:hm_productexplorer/views/home_page.dart';
import '../core/theme/theme_provider.dart';
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
    final selectedState = ref.watch(selectedCateProvider);
    final themeMode = ref.watch(themeProvider);


    return Scaffold(
      appBar: AppBar(
        title:  Text("Last Category : ${selectedState.name}"),
      ),
      body: categoriesState.when(
        data: (categories) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                // Dropdown to select a category
                Card(
                  child: Container(
                  
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.transparent,),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButton<Cate>(
                        style: const TextStyle(color: Colors.white),
                  
                        icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.white,),
                      
                        borderRadius: BorderRadius.circular(20),

                        value: selectedCategory,
                        hint: const Text("Select Category",style: TextStyle(color: Colors.white),),
                        items: [
                          ...categories.map((category) { // creating the drop down list with categories
                            return DropdownMenuItem<Cate>(
                              value: category,
                              child: Center(child: Text(category.catName ?? 'Unnamed Category',style: TextStyle(color:themeMode == ThemeMode.dark ? null : Colors.black),)),
                            );
                          }),
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                  ),
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

                              ref.read(selectedCateProvider.notifier).clearTagCodes(); // clearing the tag_codes first
                              var tags = subCategory.tagCodes; // getting the new tag_codes
                              if (tags != null && tags.isNotEmpty) {
                                for (int i = 0; i < tags.length; i++) {
                                  var tag = tags[i];
                                  ref.read(selectedCateProvider.notifier).addTagCode(tag,selectedCategory!.catName.toString()); // adding new tag_codes
                                }
                              }
                              ref.read(productNotifierProvider.notifier).fetchMoreProducts(0); // fetching the products relevant to tag code


                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(selectedIndex: 1))); // navigate to product screen






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
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}
