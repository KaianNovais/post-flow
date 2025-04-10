
import 'package:flutter/material.dart';
import 'package:post_flow/features/post/domain/entities/post_entity.dart';


class PostListItem extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onTap;

  const PostListItem({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Verificar se o corpo precisa ser truncado
    final bool isTruncated = post.body.length > 100;
    final String displayBody = isTruncated 
        ? '${post.body.substring(0, 100)}...' 
        : post.body;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                displayBody,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                ),
              ),
              if (isTruncated) ...[
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Ver mais',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}