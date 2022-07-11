import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kem/bloc/category/category_bloc.dart';
import 'package:kem/bloc/products/products_bloc.dart';
import 'package:kem/model/category.dart';
import 'package:kem/model/product.dart';
import 'package:kem/widgets/cart_icon.dart';
import 'package:kem/widgets/offers_widget.dart';
import 'package:kem/widgets/search_widget.dart';

import '../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Category> categoryList = [];
  //category list index
  int _category = 0;

  @override
  void initState() {
    ProductsBloc productsBloc =
        BlocProvider.of<ProductsBloc>(context, listen: false);
    CategoryBloc categoryBloc =
        BlocProvider.of<CategoryBloc>(context, listen: false);
    categoryBloc.add(const LoadCategoryEvent());
    productsBloc.add(const LoadProducts('All'));
    _scrollController.addListener(() {
      final maxScroll = _scrollController
          .position.maxScrollExtent; //get the maximum scroll length
      final currentScroll =
          _scrollController.position.pixels; // get the current position
      const delta = 200; // extra value our whish

      if (maxScroll < currentScroll + delta) {
        _addMore();
      }
    });
    super.initState();
  }

  void _addMore() {
    final products = BlocProvider.of<ProductsBloc>(context, listen: false);
    if (products.state is! NoMoreProducts) {
      if (products.state is ProductsLoadedState ||
          products.state is FilterProductsLoadedState) {
        products.add(LoadMoreProducts());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is LoadingMoreProducts) {
            const LinearProgressIndicator();
            ScaffoldMessengerState().removeCurrentSnackBar();
            ScaffoldMessenger.maybeOf(context)!.showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: const Text('Loading'),
                backgroundColor: Colors.green.shade100,
              ),
            );
          } else if (state is NoMoreProducts) {
            ScaffoldMessengerState().removeCurrentSnackBar();
            ScaffoldMessenger.maybeOf(context)!.showSnackBar(
              SnackBar(
                  duration: const Duration(seconds: 1),
                  content: const Text('Reached the end of the list'),
                  backgroundColor: Colors.red.shade400),
            );
          }
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                headerBuilder(context),
                offersBuilder(context),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      return categoryBuilder(context, state.categoryList);
                    } else {
                      return Container();
                    }
                  },
                )
              ]),
            ),
            BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
                print(state);
                if (state is ProductsLoadingErrorState) {
                  return Container(
                    child: Text('Error'),
                  );
                } else if (state is ProductsLoadedState) {
                  return productsBuilder(context, state.productsList);
                } else if (state is LoadingMoreProducts) {
                  return productsBuilder(context, state.productsList);
                } else if (state is NoMoreProducts) {
                  return productsBuilder(context, state.productsList);
                } else if (state is FilterProductsLoadedState) {
                  return productsBuilder(context, state.filteProductsList);
                } else {
                  return productsBuilder(context, []);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget productsBuilder(BuildContext context, List<Product> productsList) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500),
      delegate: SliverChildBuilderDelegate(
        childCount: productsList.length,
        (context, index) {
          final product = productsList[index];
          return ProductItem(product: product);
        },
      ),
    );
  }

  Widget categoryBuilder(
    BuildContext context,
    List<Category> categoryList,
  ) {
    final productsBloc = BlocProvider.of<ProductsBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: categoryList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = categoryList[index].category;
              return GestureDetector(
                onTap: () => setState(() {
                  productsBloc.add(CategorySelectedEvent(category));
                  _category = index;
                }),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _category == index
                        ? Colors.black
                        : Colors.grey.shade200,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                            color: _category == index
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget offersBuilder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20), child: const OffersWidget()),
    );
  }

  Widget headerBuilder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Search(controller: _searchController),
            )),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(onPressed: () {}, icon: CartIcon()),
            )
          ],
        ),
      ),
    );
  }
}
