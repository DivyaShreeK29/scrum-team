import 'package:flutter/material.dart';
import 'package:scrum_poker/widgets/ui/typograpy_widgets.dart';

class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("In build method of page not found");
    return Center(child: heading1(context: context, text: "hello"));
  }
}

void main()
{
  
}
