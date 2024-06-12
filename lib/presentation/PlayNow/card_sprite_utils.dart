import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

Widget getSpriteImage(int index, BuildContext context) {
  var height = AppSize.height(context, 22);
  var width = AppSize.width(context, 7);
  if (index <= 13) {
    return Container(
      height: height, //100
      width: width, //65
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: SpriteWidget(
          sprite: samllCardSpriteSheet.getSprite(0, index - 1),
        ),
      ),
    );
  } else if (index > 13 && index <= 26) {
    return Container(
      height: height, //100
      width: width, //65
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: SpriteWidget(
          sprite: samllCardSpriteSheet.getSprite(1, index - 14),
        ),
      ),
    );
  } else if (index > 26 && index <= 39) {
    return Container(
      height: height, //100
      width: width, //65
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: SpriteWidget(
          sprite: samllCardSpriteSheet.getSprite(2, index - 27),
        ),
      ),
    );
  } else if (index > 39 && index <= 52) {
    return Container(
      height: height, //100
      width: width, //65
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: SpriteWidget(
          sprite: samllCardSpriteSheet.getSprite(3, index - 40),
        ),
      ),
    );
  } else if (index > 52 && index <= 54) {
    return Container(
      height: height, //100
      width: width, //65
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: SpriteWidget(
          sprite: samllCardSpriteSheet.getSprite(4, index - 53),
        ),
      ),
    );
  } else {
    return Container(
      height: height, //100
      width: width, //65
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: SpriteWidget(
          sprite: samllCardSpriteSheet.getSprite(4, 53),
        ),
      ),
    );
  }
}
