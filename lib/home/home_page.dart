import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedgehog_test/home/home_bloc.dart';
import 'package:hedgehog_test/home/home_event.dart';
import 'package:hedgehog_test/home/home_state.dart';
import 'package:hedgehog_test/models/image_model.dart';
import 'package:hedgehog_test/views/app_loader.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  ImageListViewState createState() => ImageListViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Images'),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: const ImageListView(),
      ),
    );
  }
}

class ImageListView extends StatefulWidget {
  const ImageListView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ImageListViewState createState() => ImageListViewState();
}

class ImageListViewState extends State<ImageListView> {
  bool _isLoading = false;
  List<ImgurImage> imageList = [];
  var mPageCount = 0;
  late ScrollController _controller;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _fetchImages();
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    super.initState();
    _fetchImages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchImages() async {
    if (!_isLoading) {
      mPageCount++;
      _isLoading = true;
      setState(() {});

      BlocProvider.of<HomeBloc>(context).add(FetchTopImages(page: mPageCount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeListLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is HomeListSuccess) {
          setState(() {
            _isLoading = false;
            for (var value in state.images.images) {
              if ((value.itemType?.isNotEmpty ?? false) &&
                  (value.link?.isNotEmpty ?? false)) {
                imageList.add(value);
              }
            }
          });
        } else if (state is HomeSearchSuccess) {
          setState(() {});
        } else if ((state is HomeListFailure)) {
          setState(() {
            _isLoading = false;

            if (mPageCount > 0) {
              mPageCount--;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.apiError),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Column(
        children: [
          _buildSearchBar(),
          _buildListView(),
          AppLoader(isLoading: _isLoading)
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: TextField(
          onChanged: (query) {
            // BlocProvider.of<HomeBloc>(context)
            //     .add(Search(query: query, allImage: imageList));
          },
          decoration: const InputDecoration(
            labelText: 'Search Images',
            hintText: 'Enter image name...',
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView(
        controller: _controller,
        children: List.generate(
          imageList.length,
          (index) {
            var image = imageList[index];
            print('--------------------$index--------------------');
            print(image.link);
            return _buildTileView(image);
          },
        ),
      ),
    );
  }

  Widget _buildTileView(ImgurImage image) {
    return ListTile(
      leading: SizedBox(
        width: 100,
        height: 100,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/placeholder.jpg',
          image: image.link ?? '',
          fit: BoxFit.cover,
        ),
      ),
      title: Text(image.title ?? ''),
    );
  }
}
