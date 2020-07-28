import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String userId;
  int rating;
  String review;

  Review({
    this.userId,
    this.rating,
    this.review,
  });

  Review.fromDocumentSnapshot({DocumentSnapshot doc}) {
    userId = doc.documentID;
    rating = doc.data["rating"];
    review = doc.data["review"];
  }
}
