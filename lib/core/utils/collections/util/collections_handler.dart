import 'package:final_project/core/utils/collections/repository/collection_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> submitCollection({
  required String collectionName,
  required BuildContext context,
  required VoidCallback onLoadingStart,
  required VoidCallback onLoadingEnd,
  required VoidCallback onSuccess,
}) async {
  final repository = CollectionRepository();

  if (collectionName.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Collection name cannot be empty')),
    );
    return;
  }

  onLoadingStart();

  try {
    await repository.createCollection(collectionName);
    onLoadingEnd();

    Fluttertoast.showToast(
      msg: "Collection created successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.teal,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    onSuccess();
  } catch (e) {
    onLoadingEnd();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error creating collection: $e')),
    );
  }
}
