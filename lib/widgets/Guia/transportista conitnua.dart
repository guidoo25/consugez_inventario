import 'package:consugez_inventario/providers/formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormTransportista extends ConsumerStatefulWidget {
  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends ConsumerState<FormTransportista> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Dirección de partida'),
            onChanged: (value){
              ref.read(formDataProvider.notifier).updateValue('direccion', value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingrese una dirección';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Transportista'),
            //permitir solo el uso de numeros
            keyboardType: TextInputType.number,
            onChanged: (value){
              ref.read(formDataProvider.notifier).updateValue('transportista', value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingrese un transportista';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'RUC Transportista'),
            onChanged:  (value){
              ref.read(formDataProvider.notifier).updateValue('ruc', value);
            },
            maxLength: 13,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingrese un RUC';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Placa'),
            onChanged:  (value){
              ref.read(formDataProvider.notifier).updateValue('placa', value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingrese una placa';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Motivo de traslado'),
            onChanged: (value){
              ref.read(formDataProvider.notifier).updateValue('motivo', value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingrese un motivo de traslado';
              }
              return null;
            },
          ),

        ],
      ),
    );
  }
}