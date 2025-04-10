import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_flow/features/post/presentation/bloc/post_bloc.dart';
import 'package:post_flow/features/post/presentation/bloc/post_event.dart';
import 'package:post_flow/features/post/presentation/bloc/post_state.dart';
import 'package:post_flow/core/widgets/custom_snackbar.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:post_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:post_flow/features/post/presentation/pages/post_detail_page.dart';
import 'package:post_flow/features/post/presentation/widgets/post_list_item.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _scrollController = ScrollController();
  bool _isBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostBloc>().add(const FetchPostsEvent(refresh: true));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      setState(() {
        _isBottom = true;
      });
      context.read<PostBloc>().add(FetchMorePostsEvent());
      setState(() {
        _isBottom = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Flow'),
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
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
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PostBloc>()
                    .add(const FetchPostsEvent(refresh: true));
              },
              child: state.posts.isEmpty
                  ? const Center(child: Text('Nenhum post encontrado'))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.posts.length + (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= state.posts.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final post = state.posts[index];
                        return PostListItem(
                          post: post,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<PostBloc>.value(
                                  value: context.read<PostBloc>(),
                                  child: PostDetailPage(postId: post.id),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            );
          } else {
            return const Center(child: Text('Carregue os posts'));
          }
        },
      ),
    );
  }
}
