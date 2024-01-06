import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedgehog_test/home/home_bloc.dart';
import 'package:hedgehog_test/home/home_event.dart';
import 'package:hedgehog_test/home/home_state.dart';
import 'package:hedgehog_test/image_detail/image_detail_page.dart';
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
  late ScrollController _scrollController;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _fetchImages();
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
    _fetchImages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchImages() async {
    if (!_isLoading) {
      mPageCount++;
      _isLoading = true;
      setState(() {});

      BlocProvider.of<HomeBloc>(context)
          .add(FetchTopImages(page: mPageCount, searchQuery: searchQuery));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeListLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is HomeListSuccess) {
            setState(() {
              _isLoading = false;
              if (mPageCount == 1) {
                imageList = [];
              }
              for (var value in state.images.images) {
                if ((value.itemType?.isNotEmpty ?? false) &&
                    (value.link?.isNotEmpty ?? false)) {
                  imageList.add(value);
                }
              }
            });
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
        child: Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(),
                _buildListView(),
              ],
            ),
            AppLoader(isLoading: _isLoading)
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: (query) {
          searchQuery = query;
          mPageCount = 0;
          _fetchImages();
        },
        decoration: InputDecoration(
          labelText: 'Search Images',
          hintText: 'Enter image name...',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              searchQuery = '';
              mPageCount = 0;
              _fetchImages();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView(
        controller: _scrollController,
        children: List.generate(
          imageList.length,
          (index) {
            var image = imageList[index];
            return _buildTileView(image);
          },
        ),
      ),
    );
  }

  Widget _buildTileView(ImgurImage image) {
    return ListTile(
      onTap: () {
        _navigateToDetailPage(image);
      },
      leading: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/placeholder.jpg',
          image: image.link ?? '',
          fit: BoxFit.cover,
        ),
      ),
      title: Text(image.title ?? ''),
    );
  }

  _navigateToDetailPage(ImgurImage image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailPage(imgurImage: image),
      ),
    );
  }
}
