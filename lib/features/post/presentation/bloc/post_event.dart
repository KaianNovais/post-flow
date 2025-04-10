import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {
  final bool refresh;

  const FetchPostsEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class FetchMorePostsEvent extends PostEvent {}

class FetchPostDetailEvent extends PostEvent {
  final int postId;

  const FetchPostDetailEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}


class RestorePostsEvent extends PostEvent {}