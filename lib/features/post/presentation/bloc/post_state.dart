import 'package:equatable/equatable.dart';
import 'package:post_flow/features/auth/domain/entities/user_entity.dart';
import 'package:post_flow/features/post/domain/entities/post_entity.dart';


abstract class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostsLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<PostEntity> posts;
  final bool hasReachedMax;
  final int currentPage;

  const PostsLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  PostsLoaded copyWith({
    List<PostEntity>? posts,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax, currentPage];
}

class PostDetailLoading extends PostState {}

class PostDetailLoaded extends PostState {
  final PostEntity post;
  final UserEntity author;

  const PostDetailLoaded({
    required this.post,
    required this.author,
  });

  @override
  List<Object?> get props => [post, author];
}

class PostError extends PostState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object?> get props => [message];
}