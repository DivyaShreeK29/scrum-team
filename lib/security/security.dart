import 'package:flutter/material.dart';

class securityPage extends StatefulWidget {
  const securityPage({this.str, Key? key}) : super(key: key);
  final String? str;
  @override
  State<securityPage> createState() => _securityPageState();
}

class _securityPageState extends State<securityPage> {
  @override
  void initState() {
    super.initState();

    print("IN security page");
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _id = TextEditingController();
    return Container(
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: _id,
              decoration: InputDecoration(
                  hintText: "Id",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            OutlinedButton(
                onPressed: () {
                  if (widget.str == _id.text) {
                  } else {
                    print(
                        "this session is not created by and u r not having any rights to delete");
                  }
                },
                child: Text("submit"))
          ],
        ),
      ),
    );
  }
}
