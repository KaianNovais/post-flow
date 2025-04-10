import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_flow/features/post/domain/usecases/get_post_author.dart';
import 'package:post_flow/features/post/domain/usecases/get_post_details.dart';
import 'package:post_flow/features/post/domain/usecases/get_posts.dart';
import 'package:post_flow/features/post/presentation/bloc/post_event.dart';
import 'package:post_flow/features/post/presentation/bloc/post_state.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final GetPostDetails getPostDetails;
  final GetPostAuthor getPostAuthor;
  
  static const int postsPerPage = 10;
  
  // Armazenar o estado dos posts para persistir quando retornar da tela de detalhes
  PostsLoaded? _cachedPostsState;
  
  PostBloc({
    required this.getPosts,
    required this.getPostDetails,
    required this.getPostAuthor,
  }) : super(PostInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<FetchMorePostsEvent>(_onFetchMorePosts);
    on<FetchPostDetailEvent>(_onFetchPostDetail);
    on<RestorePostsEvent>(_onRestorePosts);
  }
  
  Future<void> _onFetchPosts(FetchPostsEvent event, Emitter<PostState> emit) async {
    if (event.refresh) {
      emit(PostsLoading());
    }
    
    final result = await getPosts(const PostsParams(page: 1, limit: postsPerPage));
    
    result.fold(
      (failure) => emit(PostError(message: failure.toString())),
      (posts) {
        final newState = PostsLoaded(
          posts: posts,
          hasReachedMax: posts.length < postsPerPage,
          currentPage: 1,
        );
        
        // Armazenar o estado em cache
        _cachedPostsState = newState;
        
        emit(newState);
      },
    );
  }
  
  Future<void> _onFetchMorePosts(FetchMorePostsEvent event, Emitter<PostState> emit) async {
    final currentState = state;
    
    if (currentState is PostsLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.currentPage + 1;
      
      final result = await getPosts(PostsParams(page: nextPage, limit: postsPerPage));
      
      result.fold(
        (failure) => emit(PostError(message: failure.toString())),
        (newPosts) {
          if (newPosts.isEmpty) {
            final updatedState = currentState.copyWith(hasReachedMax: true);
            _cachedPostsState = updatedState;
            emit(updatedState);
          } else {
            final updatedState = currentState.copyWith(
              posts: [...currentState.posts, ...newPosts],
              currentPage: nextPage,
              hasReachedMax: newPosts.length < postsPerPage,
            );
            
            // Atualizar o cache
            _cachedPostsState = updatedState;
            
            emit(updatedState);
          }
        },
      );
    }
  }
  
  Future<void> _onFetchPostDetail(FetchPostDetailEvent event, Emitter<PostState> emit) async {

    emit(PostDetailLoading());
    
    final postResult = await getPostDetails(PostDetailParams(postId: event.postId));
    
    await postResult.fold(
      (failure) async {
        emit(PostError(message: failure.toString()));
      },
      (post) async {
        final authorResult = await getPostAuthor(AuthorParams(userId: post.userId));
        
        authorResult.fold(
          (failure) => emit(PostError(message: failure.toString())),
          (author) => emit(PostDetailLoaded(post: post, author: author)),
        );
      },
    );
  }
  
  // Método para restaurar o estado dos posts
  void _onRestorePosts(RestorePostsEvent event, Emitter<PostState> emit) {
    if (_cachedPostsState != null) {
      emit(_cachedPostsState!);
    } else {
      // Se não tiver cache, carrega do início
      add(const FetchPostsEvent(refresh: true));
    }
  }
}