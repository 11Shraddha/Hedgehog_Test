import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedgehog_test/manager/api_service.dart';
import 'package:hedgehog_test/home/home_event.dart';
import 'package:hedgehog_test/home/home_state.dart';
import 'package:hedgehog_test/models/image_model.dart';
import 'package:http/http.dart' as http;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  APIService apiService = APIService(httpClient: http.Client());

  HomeBloc() : super(HomeInitial()) {
    on<FetchTopImages>(_getImageList);
  }

  void _getImageList(FetchTopImages event, Emitter<HomeState> emit) async {
    emit(HomeListLoading());
    try {
      final images = await apiService.get(
          ApiUrls.topImageList
              .url(pageNumber: event.page, searchQuery: event.searchQuery),
          {});
      var data = ImgurImages.fromJson(images);
      print(data.images.length);
      emit(HomeListSuccess(data));
    } catch (e) {
      emit(HomeListFailure(apiError: 'Failed to load images'));
    }
  }
}
