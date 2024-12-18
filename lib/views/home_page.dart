import 'package:flutter/material.dart';
import 'package:hm_productexplorer/views/product_list_screen.dart';
import 'package:hm_productexplorer/views/select_category.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({super.key, required this.selectedIndex});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = widget.selectedIndex;
    });
  }

  final List<Widget> _pages = [
    const SelectCategory(),
    const ProductListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Category Navigation
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0; // Navigate to CategoryPage
                });
              },
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5, // Half width
                  height: 50,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    "Category",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Products Navigation
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 1; // Navigate to ProductsPage
                });
              },
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5, // Half width
                  height: 50,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    "Products",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
