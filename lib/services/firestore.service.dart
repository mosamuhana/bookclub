import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../models.dart';

class FirestoreService {
  Firestore _firestore = Firestore.instance;

  CollectionReference get usersCollection => _firestore.collection("users");
  CollectionReference get groupsCollection => _firestore.collection("groups");

  Future<String> createGroup(String groupName, User user, Book initialBook) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();

    try {
      members.add(user.uid);
      tokens.add(user.notifToken);
      DocumentReference _docRef;
      if (user.notifToken != null) {
        _docRef = await groupsCollection.add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'tokens': tokens,
          'groupCreated': Timestamp.now(),
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      } else {
        _docRef = await groupsCollection.add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'groupCreated': Timestamp.now(),
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      }

      await usersCollection.document(user.uid).updateData({
        'groupId': _docRef.documentID,
      });

      //add a book
      addBook(_docRef.documentID, initialBook);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, User userModel) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();
    try {
      members.add(userModel.uid);
      tokens.add(userModel.notifToken);
      await groupsCollection.document(groupId).updateData({
        'members': FieldValue.arrayUnion(members),
        'tokens': FieldValue.arrayUnion(tokens),
      });

      await usersCollection.document(userModel.uid).updateData({
        'groupId': groupId.trim(),
      });

      retVal = "success";
    } on PlatformException catch (e) {
      retVal = "Make sure you have the right group ID!";
      print(e);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> leaveGroup(String groupId, User userModel) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();
    try {
      members.add(userModel.uid);
      tokens.add(userModel.notifToken);
      await groupsCollection.document(groupId).updateData({
        'members': FieldValue.arrayRemove(members),
        'tokens': FieldValue.arrayRemove(tokens),
      });

      await usersCollection.document(userModel.uid).updateData({
        'groupId': null,
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addBook(String groupId, Book book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await groupsCollection.document(groupId).collection("books").add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await groupsCollection.document(groupId).updateData({
        "currentBookId": _docRef.documentID,
        "currentBookDue": book.dateCompleted,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addNextBook(String groupId, Book book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await groupsCollection.document(groupId).collection("books").add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await groupsCollection.document(groupId).updateData({
        "nextBookId": _docRef.documentID,
        "nextBookDue": book.dateCompleted,
      });

      //adding a notification document
      DocumentSnapshot doc = await groupsCollection.document(groupId).get();
      createNotifications(List<String>.from(doc.data["tokens"]) ?? [], book.name, book.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addCurrentBook(String groupId, Book book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await groupsCollection.document(groupId).collection("books").add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule
      await groupsCollection.document(groupId).updateData({
        "currentBookId": _docRef.documentID,
        "currentBookDue": book.dateCompleted,
      });

      //adding a notification document
      DocumentSnapshot doc = await groupsCollection.document(groupId).get();
      createNotifications(List<String>.from(doc.data["tokens"]) ?? [], book.name, book.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<Book> getCurrentBook(String groupId, String bookId) async {
    Book retVal;

    try {
      DocumentSnapshot _docSnapshot =
          await groupsCollection.document(groupId).collection("books").document(bookId).get();
      retVal = Book.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> finishedBook(
    String groupId,
    String bookId,
    String uid,
    int rating,
    String review,
  ) async {
    String retVal = "error";
    try {
      await groupsCollection
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .document(uid)
          .setData({
        'rating': rating,
        'review': review,
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> isUserDoneWithBook(String groupId, String bookId, String uid) async {
    bool retVal = false;
    try {
      DocumentSnapshot _docSnapshot = await groupsCollection
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .document(uid)
          .get();

      if (_docSnapshot.exists) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> createUser(User user) async {
    try {
      final userDocRef = usersCollection.document(user.uid);
      await userDocRef.setData({
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
    User retVal;

    try {
      DocumentSnapshot _docSnapshot = await usersCollection.document(uid).get();
      retVal = User.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createNotifications(List<String> tokens, String bookName, String author) async {
    String retVal = "error";

    try {
      await _firestore.collection("notifications").add({
        'bookName': bookName.trim(),
        'author': author.trim(),
        'tokens': tokens,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<List<Book>> getBookHistory(String groupId) async {
    List<Book> retVal = List();

    try {
      QuerySnapshot query = await groupsCollection
          .document(groupId)
          .collection("books")
          .orderBy("dateCompleted", descending: true)
          .getDocuments();

      query.documents.forEach((element) {
        retVal.add(Book.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<List<Review>> getReviewHistory(String groupId, String bookId) async {
    List<Review> retVal = List();

    try {
      QuerySnapshot query = await groupsCollection
          .document(groupId)
          .collection("books")
          .document(bookId)
          .collection("reviews")
          .getDocuments();

      query.documents.forEach((element) {
        retVal.add(Review.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
