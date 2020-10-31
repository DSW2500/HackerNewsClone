import "package:flutter/material.dart";
import 'package:news/src/widgets/loading_container.dart';
import "dart:async";
import "../models/item_model.dart";

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});
  Widget build(context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: buildText(item),
            subtitle: item.by == "" ? Text("Deleted!") : Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth + 1) * 16.0,
            ),
          ),
          Divider(
            thickness: 20.0,
          ),
        ];
        snapshot.data.kids.forEach(((kidId) {
          Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1);
        }));
        return Column(
          children: children,
        );
      },
      future: itemMap[itemId],
    );
  }

  buildText(ItemModel item) {
    final text = item.text
        .replaceAll("&#x27", "'")
        .replaceAll("<p>", "\n\n")
        .replaceAll("</p", "");
    return Text(text);
  }
}
