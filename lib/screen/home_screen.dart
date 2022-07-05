import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kem/bloc/products/products_bloc.dart';
import 'package:kem/widgets/offers_widget.dart';
import 'package:kem/widgets/search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _category = 0;
  @override
  Widget build(BuildContext context) {
    ProductsBloc productsBloc = BlocProvider.of<ProductsBloc>(context);
    productsBloc.add(const LoadProducts('All'));
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              headerBuilder(context),
              offersBuilder(context),
              categoryBuilder(context)
            ]),
          ),
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              return productsBuilder(context, productsBloc);
            },
          ),
        ],
      ),
    );
  }

  Widget productsBuilder(BuildContext context, ProductsBloc productsBloc) {
    return SliverGrid(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildBuilderDelegate(
          childCount: productsBloc.productsList.length,
          (context, index) => Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                color: Colors.amber,
              )),
    );
  }

  Widget categoryBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => setState(() {
              _category = index;
            }),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _category == index ? Colors.black : Colors.grey.shade200,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'All',
                    style: TextStyle(
                        color:
                            _category == index ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.shopping_bag),
            )
          ],
        ),
      ),
    );
  }
}
