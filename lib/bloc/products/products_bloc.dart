import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kem/model/category.dart';
import 'package:kem/model/product.dart';
import 'package:kem/repository/products_repository.dart';
import 'package:kem/utils/platform_util.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsReposiotry _reposiotry = ProductsReposiotry();
  Category _selectedCategory = Category(category: 'All');
  List<Product> _filteredList = [];
  late List<Product> _productsList = [];
  final int _limit = PlatformDetails().isBiggerScreen ? 30 : 15;
  bool _isFetchingProducts = false;
  bool _hasNext = true;

  bool get _isAll => (_selectedCategory.category == 'All');

  ProductsBloc() : super(ProductsLoadingState()) {
    on<LoadProducts>((event, emit) async {
      final newList = await _reposiotry
          .getAllProducts(_limit)
          .map((snapshot) => snapshot.docs
              .map((e) {
                return Product.fromFireBase(e.id, e.data());
              })
              .toSet()
              .toList())
          .first;
      _productsList.addAll(newList);
      emit(ProductsLoadedState(productsList: [..._productsList]));
    });
    on<LoadMoreProducts>(((event, emit) async {
      if (_isFetchingProducts) {
        _isAll
            ? emit(LoadingMoreProducts(productsList: [..._productsList]))
            : emit(LoadingMoreProducts(productsList: [..._filteredList]));
      } else if (!_hasNext) {
        _isAll
            ? emit(NoMoreProducts(productsList: [..._productsList]))
            : emit(NoMoreProducts(productsList: [..._filteredList]));
      } else {
        _isFetchingProducts = true;
        if (_isAll) {
          _isAll
              ? emit(LoadingMoreProducts(productsList: [..._productsList]))
              : emit(FilterProductsLoadedState(
                  filteProductsList: [..._filteredList]));
          final lastProduct =
              await _reposiotry.getProductDocumentSnapshot(_productsList.last);
          final newList = await _reposiotry
              .getMoreAllProducts(lastProduct, _limit)
              .map((snapshot) => snapshot.docs
                  .map((e) {
                    return Product.fromFireBase(e.id, e.data());
                  })
                  .toSet()
                  .toList())
              .first;

          if (newList.isEmpty) {
            _hasNext = false;
          }
          _isFetchingProducts = false;
          _productsList.addAll(newList);
          _isAll
              ? emit(ProductsLoadedState(productsList: [..._productsList]))
              : emit(FilterProductsLoadedState(
                  filteProductsList: [..._filteredList]));
        } else {
          if (_filteredList.isNotEmpty) {
            final last = _filteredList.last;
            final lastProduct =
                await _reposiotry.getProductDocumentSnapshot(last);
            final newList = await _reposiotry
                .getMoreProductsByCategory(
                    category: _selectedCategory.category,
                    product: lastProduct,
                    limit: _limit)
                .map((snapshot) => snapshot.docs
                    .map((e) {
                      return Product.fromFireBase(e.id, e.data());
                    })
                    .toSet()
                    .toList())
                .first;

            if (newList.isEmpty) {
              _hasNext = false;
            }
            _isFetchingProducts = false;
            _filteredList.addAll(newList);
            emit(FilterProductsLoadedState(
                filteProductsList: [..._filteredList]));
          } else {
            final newList = await _reposiotry
                .getMoreProductsByCategory(
                    category: _selectedCategory.category, limit: _limit)
                .map((snapshot) => snapshot.docs
                    .map((e) {
                      return Product.fromFireBase(e.id, e.data());
                    })
                    .toSet()
                    .toList())
                .first;
            print(newList.length);
            if (newList.isEmpty) {
              _hasNext = false;
            }
            _isFetchingProducts = false;
            _filteredList.addAll(newList);
            emit(FilterProductsLoadedState(
                filteProductsList: [..._filteredList]));
          }
        }
      }
    }));
    on<CategorySelectedEvent>(
      (event, emit) async {
        _selectedCategory = Category(category: event.category);
        if (event.category.contains('All')) {
          emit(
            FilterProductsLoadedState(filteProductsList: [..._productsList]),
          );
        } else {
          _filteredList.clear();
          final newList = _productsList.map(((e) {
            if (e.category == event.category) {
              return Product.fromMap(e.toMap());
            }
          })).toList();
          for (var element in newList) {
            if (element != null) {
              _filteredList.add(element);
            }
          }
          if (_filteredList.isNotEmpty) {
            emit(FilterProductsLoadedState(
                filteProductsList: [..._filteredList]));
          } else {
            final newList = await _reposiotry
                .getMoreProductsByCategory(
                    category: _selectedCategory.category, limit: _limit)
                .map((snapshot) => snapshot.docs
                    .map((e) {
                      return Product.fromFireBase(e.id, e.data());
                    })
                    .toSet()
                    .toList())
                .first;

            if (newList.isEmpty) {
              _hasNext = false;
            }
            _isFetchingProducts = false;
            _filteredList.addAll(newList);
            emit(FilterProductsLoadedState(
                filteProductsList: [..._filteredList]));
          }
        }
      },
    );
  }
  categorySelectedEvent(CategorySelectedEvent event, emit) async {
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
