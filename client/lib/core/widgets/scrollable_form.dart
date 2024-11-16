import 'package:flutter/material.dart';

class ScrollableForm extends StatelessWidget {
  final Widget child;
  final Key formKey;

  const ScrollableForm({
    super.key,
    required this.child,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        //call validator method inside children which are TextFormFields
        child: Form(
          key: formKey,
          child: child,
        ),
      ),
    );
  }
}
