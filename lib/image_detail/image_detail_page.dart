import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedgehog_test/home/home_bloc.dart';
import 'package:hedgehog_test/models/image_model.dart';

class ImageDetailPage extends StatelessWidget {
  final ImgurImage imgurImage;

  const ImageDetailPage({super.key, required this.imgurImage});

  ImageDetailViewState createState() => ImageDetailViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images Detail'),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: ImageDetailView(imgurImage: imgurImage),
      ),
    );
  }
}

class ImageDetailView extends StatefulWidget {
  final ImgurImage imgurImage;

  const ImageDetailView({super.key, required this.imgurImage});

  @override
  // ignore: library_private_types_in_public_api
  ImageDetailViewState createState() => ImageDetailViewState();
}

class ImageDetailViewState extends State<ImageDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  Widget _buildListView() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.imgurImage.title ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder.jpg',
              image: widget.imgurImage.link ?? '',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.imgurImage.description ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
