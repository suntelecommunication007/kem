import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kem/model/product.dart';
import 'package:kem/repository/products_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsReposiotry _reposiotry = ProductsReposiotry();

  late List<Product> productsList = [];

  ProductsBloc() : super(ProductsLoadingState()) {
    on<LoadProducts>((event, emit) async {
      if (event.category == 'All') {
        final newList = await _reposiotry
            .getAllProducts()
            .map((snapshot) => snapshot.docs.map((e) {
                  return Product.fromFireBase(e.id, e.data());
                }).toSet())
            .first;
        productsList.addAll(newList);
        print('completed ${newList.toSet().length} \n ${productsList.length}');
      } else {
        final newList = await _reposiotry
            .getProductsByCategory(event.category)
            .map((snapshot) => snapshot.docs.map((e) {
                  return Product.fromFireBase(e.id, e.data());
                }).toSet())
            .first;
        productsList.toSet().addAll(newList);
      }
      emit(ProductsLoadedState(productsList: productsList));
    });
    on<LoadMoreProducts>(((event, emit) async {
      if (event.category == 'All') {
        final lastProduct = await _reposiotry.getProductDocumentSnapshot(
            productsList[event.loadedProductsCount]);
        final newList = await _reposiotry
            .getMoreAllProducts(lastProduct)
            .map((snapshot) => snapshot.docs
                .map((e) {
                  return Product.fromFireBase(e.id, e.data());
                })
                .toSet()
                .toList())
            .first;
        productsList.toSet().addAll(newList);
      } else {
        final lastProduct = await _reposiotry.getProductDocumentSnapshot(
            productsList[event.loadedProductsCount]);
        final newList = await _reposiotry
            .getMoreProductsByCategory(event.category, lastProduct)
            .map((snapshot) => snapshot.docs
                .map((e) {
                  return Product.fromFireBase(e.id, e.data());
                })
                .toSet()
                .toList())
            .first;
        productsList.toSet().addAll(newList);
      }
      emit(ProductsLoadedState(productsList: productsList));
    }));
  }
}
