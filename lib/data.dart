import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

IconData sendIcon = Icons.mic;

final usersDB = FirebaseFirestore.instance.collection('users');