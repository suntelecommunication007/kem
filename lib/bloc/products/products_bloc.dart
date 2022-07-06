import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kem/model/product.dart';
import 'package:kem/repository/products_repository.dart';
import 'package:kem/utils/platform_util.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsReposiotry _reposiotry = ProductsReposiotry();

  late List<Product> productsList = [];
  final int _limit = PlatformDetails().isBiggerScreen ? 30 : 15;
  bool _isFetchingProducts = false;
  bool _hasNext = true;

  ProductsBloc() : super(ProductsLoadingState()) {
    on<LoadProducts>((event, emit) async {
      final newList = await _reposiotry
          .getAllProducts(_limit)
          .map((snapshot) => snapshot.docs.map((e) {
                return Product.fromFireBase(e.id, e.data());
              }).toSet())
          .first;
      productsList.addAll(newList);
      emit(ProductsLoadedState(productsList: productsList));
    });
    on<LoadMoreProducts>(((event, emit) async {
      if (_isFetchingProducts) {
        emit(LoadingMoreProducts(productsList: productsList));
      } else if (!_hasNext) {
        emit(NoMoreProducts(productsList: productsList));
      } else {
        _isFetchingProducts = true;
        emit(LoadingMoreProducts(productsList: productsList));
        final lastProduct = await _reposiotry.getProductDocumentSnapshot(
            productsList[event.loadedProductsCount]);
        final newList = await _reposiotry
            .getMoreAllProducts(lastProduct, _limit)
            .map((snapshot) => snapshot.docs
                .map((e) {
                  return Product.fromFireBase(e.id, e.data());
                })
                .toSet()
                .toList())
            .first;

        if (newList.length < _limit) {
          _hasNext = false;
        }
        _isFetchingProducts = false;
        productsList.addAll(newList);
        emit(ProductsLoadedState(productsList: productsList));
      }
    }));

    on<CategorySelectedEvent>(
      (event, emit) => categorySelectedEvent(event, emit),
    );
  }
  categorySelectedEvent(CategorySelectedEvent event, emit) async {
    List<Product> newList = [];
    productsList.map((e) {
      if (e.category == event.category) {
        newList.add(e);
      }
    }).toList();
    if (newList.isNotEmpty) {
      emit(ProductsLoadedState(productsList: newList));
    }
    // final lastProduct =
    //     await _reposiotry.getProductDocumentSnapshot(newList.last);
    // final newFirebaseList = await _reposiotry
    //     .getMoreProductsByCategory(event.category, lastProduct, _limit)
    //     .map((snapshot) => snapshot.docs
    //         .map((e) {
    //           return Product.fromFireBase(e.id, e.data());
    //         })
    //         .toSet()
    //         .toList())
    //     .first;

    // newList.toSet().addAll(newFirebaseList);
    // emit(ProductsLoadedState(productsList: newList));
  }
}
