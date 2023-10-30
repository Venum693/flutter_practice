import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  const Pagination({super.key});

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {

  List<String> items = List.generate(100, (index) => "Item $index");

  int currentPage = 1; // Initial page
  int itemsPerPage = 5; // Number of items to load per page
  List<String> allItems = []; // Total list of items
  List<String> currentItems = []; // Items to display on the current page
  bool isLoading = false; // Indicator to show whether more items are being loaded

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        // The user has reached the end of the list and more items are not being loaded.
        loadMoreItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadMoreItems() async {
    setState(() {
      isLoading = true;
    });

    // Simulate loading more items from a data source.
    await Future.delayed(Duration(seconds: 1)); // Simulate a network request.
    for (int i = 0; i < itemsPerPage; i++) {
      int nextIndex = (currentPage - 1) * itemsPerPage + i;
      if (nextIndex < allItems.length) {
        setState(() {
          currentItems.add(allItems[nextIndex]);
        });
      }
    }
    currentPage++;

    setState(() {
      isLoading = false;
    });
  }

  void initializeItems() {
    for (int i = 0; i < 100; i++) {
      allItems.add("Item $i");
    }
    loadMoreItems(); // Load initial items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ONDC Cart'),
      ),
      body: ListView.builder(
        itemCount: currentItems.length, // This ensures that we only try to access items in the list that are within the bounds of the list.
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          // ...
        },
      ),
    );
  }
}
