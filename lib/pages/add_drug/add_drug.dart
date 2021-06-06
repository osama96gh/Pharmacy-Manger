import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_manager/app_state.dart';
import 'package:pharmacy_manager/models/drug.dart';
import 'package:provider/provider.dart';

class AddDrugScreen extends StatefulWidget {
  final Drug? drug;
  final String serialNumber;

  AddDrugScreen({Key? key, required this.serialNumber, this.drug})
      : super(key: key);

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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _timeController.text = formatter.format(selectedDate);
      });
    }
  }

  void _addDrug(Drug drug) async {
    isUploading=true;
    DocumentReference documentReference= await Provider.of<ApplicationState>(context, listen: false).addDrugToFirestore(drug);
    isUploading=false;
    print(documentReference);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _timeController.text = formatter.format(selectedDate);
    _serialController.text = widget.serialNumber;

    Future.delayed(Duration(milliseconds: 50)).then((value) => pickDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drug == null ? 'Add Drug' : 'Edit Drug'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Drug Name:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Drug Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Drug Name to continue';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Drug Serial Number:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _serialController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Drug Serial Number',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Drug Serial Number to continue';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expiration date:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      onTap: () async {
                        pickDate();
                      },
                      readOnly: true,
                      controller: _timeController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Expiration date',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Expiration date to continue';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Drug Description:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Description',
                      ),
                      validator: (value) {
                        // if (value!.isEmpty) {
                        //   return 'Enter Description to continue';
                        // }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: isUploading?CircularProgressIndicator(): Icon(Icons.done),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _addDrug(Drug(
                serial: _serialController.text,
                name: _nameController.text,
                expiredAt: selectedDate.millisecondsSinceEpoch,
                description: _descriptionController.text));
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
