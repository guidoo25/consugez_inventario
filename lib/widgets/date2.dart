import 'package:consugez_inventario/providers/formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DatepickerFin extends ConsumerStatefulWidget {
  final String  labeltext;

  const DatepickerFin({super.key, required this.labeltext});

  @override
  _DatepickerState createState() => _DatepickerState();

}

class _DatepickerState extends ConsumerState<DatepickerFin>{
  TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(30.0),
      child: TextField(
        controller: _dateController,
        decoration: InputDecoration(
          hintText: '${widget.labeltext}',
          suffixIcon: Icon(Icons.calendar_today),

        ),
        onTap: () async{
          DateTime? pickdate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime(2050),

          );
          if(pickdate != null){
            setState(() {
              _dateController.text = DateFormat('dd/MM/yyyy').format(pickdate).toString();
              ref.read(formDataProvider.notifier).updateValue('fechafin', DateFormat('dd/MM/yyyy').format(pickdate).toString());
            });
          }

        },

      ),

    );

  }


}