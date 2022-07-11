import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kem/bloc/cart/cart_bloc.dart';
import 'package:kem/model/cart_item.dart';

import 'package:kem/model/product.dart';
import '../widgets/cart_icon.dart';

class ProductDetailScreen extends StatefulWidget {
  static String routeName = '/productDetailsScreen';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double? _price = 0;
  int _priceConfigSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _buildBottomSheet(context, product),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: false,
              title: Text(product.name),
              actions: [
                IconButton(
                    padding: const EdgeInsets.only(right: 20),
                    onPressed: () {},
                    icon: CartIcon())
              ],
              expandedHeight: 300,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHw%3D&w=1000&q=80'))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          softWrap: false,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          product.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        '$_price',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: product.priceConfig.keys.length,
                (context, index) {
                  List<String> keys = product.priceConfig.keys.toList();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () => setState(() {
                        _price = product.priceConfig[keys[index]];
                        _priceConfigSelectedIndex = index;
                      }),
                      selectedColor: Colors.white,
                      selectedTileColor: Colors.green,
                      selected: _priceConfigSelectedIndex == index,
                      leading: Text(keys[index]),
                      trailing: Text('${product.priceConfig[keys[index]]}'),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildBottomSheet(BuildContext context, Product product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Row(
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    minimumSize: const Size(60, 60)),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onPressed: () {},
              ),
            )),
            GestureDetector(
              onTap: () {
                BlocProvider.of<CartBloc>(context).add(AddToCart(CartItem(
                    count: 1,
                    productId: product.id,
                    priceConfigKey: product.priceConfig.keys
                        .toList()[_priceConfigSelectedIndex])));
              },
              child: Container(
                height: 60,
                width: 60,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.shopping_bag),
              ),
            )
          ],
        ),
      ),
    );
  }
}
