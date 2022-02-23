import 'package:flutter/material.dart';
import 'package:hint/ui/views/reels_testing/widgets/display_video.dart';
import 'package:insta_public_api/insta_public_api.dart';
import 'package:insta_public_api/models/basic_model.dart';

class ReelsView extends StatefulWidget {
  const ReelsView({Key? key}) : super(key: key);

  @override
  _ReelsViewState createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  final ipa = InstaPublicApi('kyliejenner',postsLimit: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: ipa.getAllPosts(),
        builder: (context, AsyncSnapshot<List<Post>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Post>? posts = snapshot.data;

          return ListView.builder(
            itemCount: posts?.length,
            itemBuilder: (_, index) {
              final post = posts![index];
              
              return SizedBox(
                child: post.isVideo!
                    ? VideoPlayerScreen(videoURL: post.displayUrl!)
                    : Image.network(post.displayUrl!),
              );
            },
          );
        },
      ),
    );
  }
}
