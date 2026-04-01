import 'package:flutter/material.dart';

/// Mixin that adds pagination state and scroll-to-load-more logic.
/// Use with a StatefulWidget's State class.
///
/// Usage:
/// ```dart
/// class _MyListState extends State<MyList> with PaginatedListMixin<MyList, MyItem> {
///   @override
///   Future<List<MyItem>> fetchPage(int page) async { ... }
/// }
/// ```
mixin PaginatedListMixin<T extends StatefulWidget, I> on State<T> {
  final ScrollController paginationController = ScrollController();

  List<I> items = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  /// Override: how many items per page.
  int get pageSize => 20;

  /// Override: fetch a page of data.
  Future<List<I>> fetchPage(int page);

  @override
  void initState() {
    super.initState();
    paginationController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    paginationController.removeListener(_onScroll);
    paginationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    final page = await fetchPage(1);
    if (!mounted) return;
    setState(() {
      items = page;
      currentPage = 1;
      hasMore = page.length >= pageSize;
    });
  }

  void _onScroll() {
    if (isLoadingMore || !hasMore) return;
    if (paginationController.position.pixels >=
        paginationController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore || !hasMore) return;
    setState(() => isLoadingMore = true);

    final nextPage = currentPage + 1;
    final page = await fetchPage(nextPage);
    if (!mounted) return;

    setState(() {
      items.addAll(page);
      currentPage = nextPage;
      hasMore = page.length >= pageSize;
      isLoadingMore = false;
    });
  }

  /// Call this to refresh the list from page 1.
  Future<void> refreshList() async {
    setState(() {
      currentPage = 1;
      hasMore = true;
    });
    await _loadInitial();
  }

  /// Standard loading-more indicator to append at the bottom of your ListView.
  Widget buildLoadingIndicator() {
    if (!isLoadingMore) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
