import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedgehog_test/home/home_bloc.dart';
import 'package:hedgehog_test/home/home_event.dart';
import 'package:hedgehog_test/home/home_page.dart';
import 'package:hedgehog_test/home/home_state.dart';
import 'package:hedgehog_test/manager/api_service.dart';
import 'package:hedgehog_test/models/image_model.dart';
import 'package:hedgehog_test/views/app_loader.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  testWidgets('ImageListView displays loading indicator when loading',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({"key": "value"}), 200);
      });

      final homeBloc = HomeBloc();
      homeBloc.apiService = APIService(httpClient: mockClient);

      final widget = MaterialApp(
        home: BlocProvider(
          create: (context) => homeBloc,
          child: const ImageListView(),
        ),
      );

      homeBloc.add(FetchTopImages(page: 0));

      await tester.pumpWidget(widget);

      await tester.pumpAndSettle();

      expect(find.byType(AppLoader), findsOneWidget);
    });
  });

  testWidgets('ImageListView displays Images when loaded',
      (WidgetTester tester) async {
    final homeBloc = HomeBloc();
    final images = [ImgurImage(itemType: 'jpeg'), ImgurImage(itemType: 'jpeg')];

    final widget = MaterialApp(
      home: BlocProvider(
        create: (context) => homeBloc,
        child: const ImageListView(),
      ),
    );

    homeBloc.emit(HomeListSuccess(ImgurImages(images: images)));

    await tester.pumpWidget(widget);

    expect(find.text('image 1'), findsOneWidget);
    expect(find.text('image 2'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('ImageListView displays error message when loading fails',
      (WidgetTester tester) async {
    final homeBloc = HomeBloc();
    const errorMessage = 'Failed to load Images';
    final widget = MaterialApp(
      home: BlocProvider(
        create: (context) => homeBloc,
        child: const ImageListView(),
      ),
    );

    homeBloc.emit(HomeListFailure(apiError: errorMessage));

    await tester.pumpWidget(widget);

    expect(find.text(errorMessage), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('ImageListView updates list when searching for Images',
      (WidgetTester tester) async {
    final homeBloc = HomeBloc();
    final images = [ImgurImage(itemType: 'jpeg'), ImgurImage(itemType: 'jpeg')];

    final widget = MaterialApp(
      home: BlocProvider(
        create: (context) => homeBloc,
        child: const ImageListView(),
      ),
    );

    homeBloc.emit(HomeListSuccess(ImgurImages(images: images)));

    await tester.pumpWidget(widget);

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'Image 1');

    expect(find.text('Image 1'), findsOneWidget);
    expect(find.text('Image 2'), findsNothing);

    await tester.enterText(searchField, 'Image 2');

    expect(find.text('Image 1'), findsNothing);
    expect(find.text('Image 2'), findsOneWidget);
  });
}
