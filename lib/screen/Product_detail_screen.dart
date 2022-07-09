import 'package:flutter/material.dart';

import 'package:kem/model/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static String routeName = '/productDetailsScreen';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double? _price = 0;
  int _priceConfigSelectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      bottomNavigationBar: _buildBottomSheet(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            title: Text(product.name),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.shopping_cart))
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
            child: Text('$_price'),
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
    );
  }

  Container _buildBottomSheet(BuildContext context) {
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
              child: Expanded(
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
              ),
            )),
            Container(
              height: 60,
              width: 60,
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
