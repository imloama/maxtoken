import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


final router = Router();

void init(){
  router.define("/home", handler: Handler(
    handlerFunc:  (BuildContext context, Map<String, dynamic> params) {
      //return UsersScreen(params["id"][0]);
      return null;
    }));
}