import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../models.dart';

class FirestoreService {
  Firestore _firestore = Firestore.instance;

  CollectionReference get usersCollection => _firestore.collection("users");
  CollectionReference get groupsCollection => _firestore.collection("groups");
  CollectionReference get notificationsCollection => _firestore.collection("notifications");

  Future<String> createGroup(String groupName, User user, Book initialBook) async {
    String result = "error";
    try {
      final groupData = <String, dynamic>{
        'name': groupName.trim(),
        'leader': user.uid,
        'members': <String>[user.uid],
        'groupCreated': Timestamp.now(),
        'nextBookId': "waiting",
        'indexPickingBook': 0,
      };

      if (user.notifToken != null) {
        groupData['tokens'] = <String>[user.notifToken];
      }

      final groupRef = await groupsCollection.add(groupData);
      final groupId = groupRef.documentID;

      await usersCollection.document(user.uid).updateData({'groupId': groupId});

      //add a book
      addBook(groupId, initialBook);

      result = "success";
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> joinGroup(String groupId, User user) async {
    String result = "error";
    try {
      await groupsCollection.document(groupId).updateData({
        'members': FieldValue.arrayUnion(<String>[user.uid]),
        'tokens': FieldValue.arrayUnion(<String>[user.notifToken]),
      });

      await usersCollection.document(user.uid).updateData({'groupId': groupId});

      result = "success";
    } on PlatformException catch (e) {
      result = "Make sure you have the right group ID!";
      print(e);
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> leaveGroup(String groupId, User user) async {
    String result = "error";
    try {
      await groupsCollection.document(groupId).updateData({
        'members': FieldValue.arrayRemove(<String>[user.uid]),
        'tokens': FieldValue.arrayRemove(<String>[user.notifToken]),
      });

      await usersCollection.document(user.uid).updateData({'groupId': null});
      result = 'success';
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> addBook(String groupId, Book book) async {
    String result = "error";

    try {
      final bookRef = await groupsCollection.document(groupId).collection("books").add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await groupsCollection.document(groupId).updateData({
        "currentBookId": bookRef.documentID,
        "currentBookDue": book.dateCompleted,
      });

      result = "success";
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> addNextBook(String groupId, Book book) async {
    String retVal = "error";

    try {
      DocumentReference bookRef = await groupsCollection.document(groupId).collection("books").add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await groupsCollection.document(groupId).updateData({
        "nextBookId": bookRef.documentID,
        "nextBookDue": book.dateCompleted,
      });

      //adding a notification document
      final groupDoc = await groupsCollection.document(groupId).get();
      createNotifications(List<String>.from(groupDoc.data["tokens"]) ?? [], book.name, book.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addCurrentBook(String groupId, Book book) async {
    String result = "error";

    try {
      DocumentReference bookRef = await groupsCollection.document(groupId).collection("books").add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await groupsCollection.document(groupId).updateData({
        "currentBookId": bookRef.documentID,
        "currentBookDue": book.dateCompleted,
      });

      //adding a notification document
      DocumentSnapshot groupDoc = await groupsCollection.document(groupId).get();
      createNotifications(List<String>.from(groupDoc.data["tokens"]) ?? [], book.name, book.author);

      result = "success";
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<Book> getCurrentBook(String groupId, String bookId) async {
    Book result;

    try {
      DocumentSnapshot bookDoc =
          await groupsCollection.document(groupId).collection("books").document(bookId).get();
      result = Book.fromDocumentSnapshot(doc: bookDoc);
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> finishedBook(
    String groupId,
    String bookId,
    String uid,
    int rating,
    String review,
  ) async {
    String result = "error";
    final data = <String, dynamic>{
      'rating': rating,
      'review': review,
    };
    try {
      await groupsCollection
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .document(uid)
          .setData(data);
      result = "success";
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<bool> isUserDoneWithBook(String groupId, String bookId, String uid) async {
    try {
      final doc = await groupsCollection
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .document(uid)
          .get();

      return doc.exists;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> createUser(User user) async {
    try {
      final userRef = usersCollection.document(user.uid);
      await userRef.setData({
        'fullName': user.fullName.trim(),
        'email': user.email.trim(),
        'accountCreated': Timestamp.now(),
        'notifToken': user.notifToken,
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<User> getUser(String uid) async {
    try {
      final userDoc = await usersCollection.document(uid).get();
      return User.fromDocumentSnapshot(doc: userDoc);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> createNotifications(List<String> tokens, String bookName, String author) async {
    String result = "error";

    try {
      await notificationsCollection.add({
        'bookName': bookName.trim(),
        'author': author.trim(),
        'tokens': tokens,
      });
      result = "success";
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<List<Book>> getBookHistory(String groupId) async {
    try {
      final query = await groupsCollection
          .document(groupId)
          .collection("books")
          .orderBy("dateCompleted", descending: true)
          .getDocuments();

      return query.documents.map((doc) => Book.fromDocumentSnapshot(doc: doc)).toList();
    } catch (e) {
      print(e);
    }
    return <Book>[];
  }

  Future<List<Review>> getReviewHistory(String groupId, String bookId) async {
    try {
      final query = await groupsCollection
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .getDocuments();

      return query.documents.map((doc) => Review.fromDocumentSnapshot(doc: doc)).toList();
    } catch (e) {
      print(e);
    }
    return <Review>[];
  }

  Stream<User> getCurrentUser(String uid) {
    return usersCollection
        .document(uid)
        .snapshots()
        .map((doc) => User.fromDocumentSnapshot(doc: doc));
  }

  Stream<Group> getCurrentGroup(String groupId) {
    return groupsCollection
        .document(groupId)
        .snapshots()
        .map((doc) => Group.fromDocumentSnapshot(doc: doc));
  }
}
