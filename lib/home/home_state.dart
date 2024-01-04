import 'package:hedgehog_test/models/image_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeListLoading extends HomeState {}

class HomeListSuccess extends HomeState {
  final ImgurImages images;

  HomeListSuccess(this.images);
}

class HomeListFailure extends HomeState {
  final String apiError;

  HomeListFailure({required this.apiError});
}

// class HomeSearchSuccess extends HomeState {
//   final List<ImgurImages> filteredImages;

//   HomeSearchSuccess(this.filteredImages);
// }
