import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:saline_detector_app/main.dart';
import 'package:saline_detector_app/homepage.dart';

class AddCardDialog extends StatefulWidget {
  final int index;
  const AddCardDialog({Key? key, required this.index}) : super(key: key);
  @override
  AddCardDialogState createState() => AddCardDialogState();
}

class AddCardDialogState extends State<AddCardDialog> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _rgnNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shadowColor: Colors.grey,
      backgroundColor: Colors.black,
      child: Container(
        height: 400,
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 60),
              const Text(
                "ADD DETAILS",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(height: 60),
              TextFormField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Patient name',
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _rgnNumberController,
                decoration: const InputDecoration(
                  labelText: 'RGN number',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  String patientName = _patientNameController.text;
                  String rgnumber = _rgnNumberController.text;

                  final infodataref = FirebaseDatabase.instance
                      .ref('cards')
                      .child((widget.index + 1).toString())
                      .update({
                    'name': patientName,
                    'rgnnumber': rgnumber,
                    'percentage': 87.0,
                  });

                  ElevatedCard newcard1 = ElevatedCard(
                    cardId: (widget.index),
                    patientName: patientName,
                    rgnumber: rgnumber,
                  );

                  Navigator.of(context).pop(newcard1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
