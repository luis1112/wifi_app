import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

var fUsers = firestore.collection('users');
var fConnections = firestore.collection('connections');
