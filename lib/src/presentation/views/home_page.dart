import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cat_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CatViewModel>(context, listen: false).loadCats(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CatViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cats API'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search cats...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                vm.searchCats(value);
              },
            ),
          ),
        ),
      ),
      body: _buildBody(vm),
      bottomNavigationBar: _buildPagination(vm),
    );
  }

  Widget _buildBody(CatViewModel vm) {
    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null) {
      return Center(child: Text('Error: ${vm.errorMessage}'));
    }

    if (vm.cats.isEmpty) {
      return const Center(child: Text('No cats found.'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        _searchController.clear();
        await vm.loadCats(targetPage: 0);
      },
      child: ListView.builder(
        itemCount: vm.cats.length,
        itemBuilder: (context, index) {
          final cat = vm.cats[index];
          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    cat.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 200,
                          child: Center(
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            cat.origin,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            cat.intelligence.toString(),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(cat.description),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPagination(CatViewModel vm) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: vm.page > 0 ? () => vm.previousPage() : null,
            child: const Text('Previous'),
          ),
          Text('Page ${vm.page + 1}'),
          ElevatedButton(
            onPressed: vm.hasMore ? () => vm.nextPage() : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
