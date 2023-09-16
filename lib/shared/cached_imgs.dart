import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImgApp {
  postImg({imgPost, context}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: imgPost,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.30,
        width: double.infinity,
      ),
    );
  }

  profileImg({profileImg, double radius = 33, context}) {
    return CircleAvatar(
      radius: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: CachedNetworkImage(
          imageUrl: profileImg,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
