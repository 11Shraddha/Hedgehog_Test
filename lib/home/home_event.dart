import 'package:hedgehog_test/models/image_model.dart';

abstract class HomeEvent {}

class FetchTopImages extends HomeEvent {
  final int page;
  FetchTopImages({required this.page});
}

class ResetImagesEvent extends HomeEvent {}

class SearchImages extends HomeEvent {
  final String query;
  final List<ImgurImages> allImages;
  SearchImages({required this.query, required this.allImages});
}
