 import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_manager/app_state.dart';
import 'package:pharmacy_manager/models/drug.dart';
import 'package:provider/provider.dart';

class AddDrugScreen extends StatefulWidget {
  final Drug? drug;
  final String serialNumber;
  late final isOpenForEdit;

  AddDrugScreen({Key? key, required this.serialNumber, this.drug})
      : super(key: key) {
    isOpenForEdit = drug != null;
  }

  @override
  _AddDrugScreenState createState() => _AddDrugScreenState();
}

class _AddDrugScreenState extends State<AddDrugScreen> {
  final _nameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _timeController = TextEditingController();

  final _serialController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isUploading = false;
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  void pickDate() async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ))!;
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _timeController.text = formatter.format(selectedDate);
      });
    }
  }

  void _editDrug(Drug drug) async {
    isUploading = true;
    print('staarrrrt');
    await Provider.of<ApplicationState>(context, listen: false)
        .editDrugOnFirestore(drug);
    print('dooone');

    isUploading = false;
    Navigator.pop(context);
  }

  void _addDrug(Drug drug) async {
    isUploading = true;

        await Provider.of<ApplicationState>(context, listen: false)
            .addDrugToFirestore(drug);
    isUploading = false;
    Navigator.pop(context);
  }

  void _deleteDrug(Drug drug) async {
    isUploading = true;
    await Provider.of<ApplicationState>(context, listen: false)
        .deleteDrugFromFirestore(drug);
    isUploading = false;
    Navigator.pop(context);
  }

  @override
   void initState() {
    super.initState();
     if (widget.isOpenForEdit) {
      _nameController.text = widget.drug!.name;
      _timeController.text = formatter
          .format(DateTime.fromMillisecondsSinceEpoch(widget.drug!.expiredAt));
      _serialController.text = widget.drug!.serial;
      _descriptionController.text = widget.drug!.description!;
      selectedDate =
          DateTime.fromMillisecondsSinceEpoch(widget.drug!.expiredAt);
    } else {
      _timeController.text = formatter.format(selectedDate);
      _serialController.text = widget.serialNumber;

      Future.delayed(Duration(milliseconds: 50)).then((value) => pickDate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: widget.isOpenForEdit
            ? [
                // PopupMenuButton<String>(
                //   onSelected: (String value) {
                //     switch (value) {
                //       case 'Delete':
                //         _deleteDrug(widget.drug!);
                //         break;
                //     }
                //   },
                //   itemBuilder: (BuildContext context) {
                //     return {
                //       'Delete',
                //     }.map((String choice) {
                //       return PopupMenuItem<String>(
                //         value: choice,
                //         child: Text(
                //           choice,
                //         ),
                //       );
                //     }).toList();
                //   },
                // ),
                IconButton(
                    onPressed: () {
                      _deleteDrug(widget.drug!);
                    },
                    icon: Icon(Icons.delete_rounded))
              ]
            : [],
        title: Text(widget.isOpenForEdit ? 'Edit Drug' : 'Add Drug'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(

                    controller: _nameController,
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Drug Name",
                      hintText: 'Enter Drug Name',
                      icon: Icon(Icons.title)
                     ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Drug Name to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    controller: _serialController,
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Serial Number",
                      hintText: 'Enter Drug Serial Number',
                      icon: Icon(Icons.confirmation_num_outlined)
                    ) ,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Drug Serial Number to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    onTap: () async {
                      pickDate();
                    },
                    readOnly: true,
                    controller: _timeController,
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Expiration date",
                      hintText: 'Enter Expiration date',
                        icon: Icon(Icons.date_range),

                    )  ,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Expiration date to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Description",
                      hintText: 'Enter Description',
                      icon: Icon(Icons.description_outlined),

                    )  ,
                    validator: (value) {
                      // if (value!.isEmpty) {
                      //   return 'Enter Description to continue';
                      // }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: isUploading
            ? CircularProgressIndicator(
                color: Colors.amber,
              )
            : Icon(Icons.done),
        onPressed: isUploading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  Drug d = Drug(
                      serial: _serialController.text,
                      name: _nameController.text,
                      expiredAt: selectedDate.millisecondsSinceEpoch,
                      description: _descriptionController.text);
                  if (widget.isOpenForEdit) {
                    d.id = widget.drug!.id;
                    _editDrug(d);
                  } else {
                    _addDrug(d);
                  }
                }
              },
      ),
    );
  }
}
