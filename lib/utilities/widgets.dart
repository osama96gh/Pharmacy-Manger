import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_manager/models/drug.dart';
import 'package:pharmacy_manager/pages/add_drug/add_drug.dart';
import 'package:pharmacy_manager/utilities/enums.dart';

class Header extends StatelessWidget {
  const Header(this.heading);

  final String heading;

  @override
  Widget build(BuildContext context) =>
      Padding(
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
  Widget build(BuildContext context) =>
      Padding(
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
  Widget build(BuildContext context) =>
      Padding(
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
  Widget build(BuildContext context) =>
      OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.deepPurple)),
        onPressed: onPressed,
        child: child,
      );
}

class DrugCard extends StatelessWidget {
  final Drug drug;

  _getDrugColor() {
    switch (drug.drugState) {
      case DrugState.expired:
        return Colors.red;

      case DrugState.shortExpired:
        return Colors.orange;

      case DrugState.longExpired:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  DrugCard({Key? key, required this.drug}) : super(key: key);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddDrugScreen(serialNumber: drug.serial, drug: drug,);
            },));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 20, color: _getDrugColor()),
              ),
              // borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      drug.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 25,
                          child: Text(
                            "Serial: ",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )),
                      Expanded(
                        flex: 75,
                        child: Text(
                          drug.serial,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 25,
                          child: Text(
                            "Expire at: ",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )),
                      Expanded(
                        flex: 75,
                        child: Text(
                          '${drug.remainDaysToExpired} days',
                          style: TextStyle(
                              color: _getDrugColor(),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
