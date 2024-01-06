import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedgehog_test/home/home_bloc.dart';
import 'package:hedgehog_test/home/home_page.dart';
import 'package:hedgehog_test/home/home_state.dart';
import 'package:hedgehog_test/manager/api_service.dart';
import 'package:hedgehog_test/models/image_model.dart';
import 'package:hedgehog_test/views/app_loader.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('ImageListViewState tests', () {
    late HomeBloc homeBloc;
    late http.Client mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        return http.Response(
            jsonEncode({
              "data": [
                {"id": "1", "title": "Test Image"}
              ]
            }),
            200);
      });

      homeBloc = HomeBloc();
      homeBloc.apiService = APIService(httpClient: mockClient);
    });

    tearDown(() {
      homeBloc.close();
    });

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

        await tester.pumpWidget(widget);

        await tester.pumpAndSettle();

        expect(find.byType(AppLoader), findsOneWidget);
      });
    });

    testWidgets('ImageListView displays error message when loading fails',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient((request) async {
          return http.Response(jsonEncode({"key": "value"}), 400);
        });

        final homeBloc = HomeBloc();
        homeBloc.apiService = APIService(httpClient: mockClient);
        const errorMessage = 'Failed to load Images';

        final widget = MaterialApp(
          home: BlocProvider(
            create: (context) => homeBloc,
            child: const ImageListView(),
          ),
        );

        // homeBloc.emit(HomeListFailure(apiError: errorMessage));

        await tester.pumpWidget(widget);

        await tester.pumpAndSettle();

        // expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });
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
