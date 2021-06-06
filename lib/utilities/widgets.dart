import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_manager/models/drug.dart';

class Header extends StatelessWidget {
  const Header(this.heading);

  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: TextStyle(fontSize: 24),
        ),
      );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content);

  final String content;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: TextStyle(fontSize: 18),
        ),
      );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail);

  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(
              detail,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.deepPurple)),
        onPressed: onPressed,
        child: child,
      );
}

class DrugCard extends StatelessWidget {
  final Drug drug;

  DrugCard({Key? key, required this.drug}) : super(key: key);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    drug.name,textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(flex: 25,child: Text("Serial: ")),
                    Expanded(flex: 75,
                      child: Text(
                        drug.serial,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(flex: 25,child: Text("Expire at: ")),
                    Expanded(flex: 75,
                      child: Text(
                        formatter.format(DateTime.fromMillisecondsSinceEpoch(
                            drug.expiredAt)),
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              ( drug.description == null || drug.description!.isEmpty)
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 25,
                              child: Text("Description: ")),
                          Expanded(
                            flex:75,
                            child: Text(
                              drug.description!,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
