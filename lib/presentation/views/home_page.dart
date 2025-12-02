import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cat_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatViewModel>().loadCats();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<CatViewModel>().loadCats();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Breeds'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search breeds...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {
                context.read<CatViewModel>().searchCats(value);
              },
            ),
          ),
        ),
      ),
      body: Consumer<CatViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.cats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null && viewModel.cats.isEmpty) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _searchController.clear();
              await viewModel.loadCats(refresh: true);
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: viewModel.cats.length + (viewModel.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == viewModel.cats.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final cat = viewModel.cats[index];
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
                            Text(
                              cat.origin,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cat.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
