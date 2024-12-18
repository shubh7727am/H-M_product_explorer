import 'package:flutter/material.dart';
import 'package:hm_productexplorer/views/product_list_screen.dart';
import 'package:hm_productexplorer/views/select_category.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({super.key , required this.selectedIndex });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int _currentIndex ;

  @override
  void initState() {
    // TODO: implement initState
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
        width: double.infinity,
        height: 100,
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0; // Navigate to CategoryPage
                });
              },
              child: Text(
                "Category",
                style: TextStyle(
                  color: _currentIndex == 0 ? Colors.white : Colors.grey[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 1; // Navigate to ProductsPage
                });
              },
              child: Text(
                "Products",
                style: TextStyle(
                  color: _currentIndex == 1 ? Colors.white : Colors.grey[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}