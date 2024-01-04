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
      final images = await apiService
          .get(ApiUrls.topImageList.url(parameter: event.page), {});
      var data = ImgurImages.fromJson(images);
      emit(HomeListSuccess(data));
    } catch (e) {
      emit(HomeListFailure(apiError: 'Failed to load images'));
    }
  }
}
