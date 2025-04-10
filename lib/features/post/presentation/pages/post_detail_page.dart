import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_flow/core/widgets/custom_snackbar.dart';
import 'package:post_flow/features/post/presentation/bloc/post_bloc.dart';
import 'package:post_flow/features/post/presentation/bloc/post_event.dart';
import 'package:post_flow/features/post/presentation/bloc/post_state.dart';


class PostDetailPage extends StatefulWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    super.initState();
    final currentState = context.read<PostBloc>().state;

    if (currentState is! PostDetailLoaded || 
        (currentState.post.id != widget.postId)) {
      context.read<PostBloc>().add(FetchPostDetailEvent(postId: widget.postId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<PostBloc>().add(RestorePostsEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Post'),
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<PostBloc>().add(RestorePostsEvent());
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostError) {
              CustomSnackbar.show(
                context: context,
                message: state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            if (state is PostDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostDetailLoaded) {
              final post = state.post;
              final author = state.author;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: author.photoUrl != null && author.photoUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    author.photoUrl!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  author.displayName?[0] ?? '?',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          author.displayName ?? 'Autor desconhecido',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          post.body,
                          style: const TextStyle(
                            fontSize: 16.0,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Não foi possível carregar os detalhes do post'));
            }
          },
        ),
      ),
    );
  }
}