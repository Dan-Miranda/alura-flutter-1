import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const BytebankApp());

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListaTransferencia(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blueAccent[700],
          primary: Colors.green[900],
        ),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final FocusNode focusNode = FocusNode();
  FormularioTransferencia({Key? key}) : super(key: key);

  final TextEditingController _numeroContaController = TextEditingController();
  final TextEditingController _valorTrasnferenciaContaController =
      TextEditingController();

  _validarEntradas(BuildContext context) {
    if (_numeroContaController.text.isNotEmpty &&
        _valorTrasnferenciaContaController.text.isNotEmpty) {
      _criarTransferencia(context);
    } else {
      print("Não pode ser vazio");
    }
  }

  _criarTransferencia(BuildContext context) {
    final String numeroConta =
        _numeroContaController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final double valorTransferencia =
        double.parse(_valorTrasnferenciaContaController.text);

    final novaTransferencia = Transferencia(numeroConta, valorTransferencia);
    Navigator.pop(context, novaTransferencia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criando Tranferências',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InputTransferencia(
              controller: _numeroContaController,
              label: 'Número da conta',
              placeholder: '0000',
              formatadores: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            InputTransferencia(
                controller: _valorTrasnferenciaContaController,
                label: 'Valor',
                placeholder: '00.00',
                icone: Icons.monetization_on),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _validarEntradas(context),
                child: const Text('Confirmar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertaDialog extends StatefulWidget {
  AlertaDialog({Key? key}) : super(key: key);
  late bool isDialogAlert = false;

  @override
  _AlertaDialogState createState() => _AlertaDialogState();
}

class _AlertaDialogState extends State<AlertaDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('This is a demo alert dialog.'),
            Text('Would you like to approve of this message?'),
          ],
        ),
      ),
      actions: [
        FlatButton(
          textColor: const Color(0xFF6200EE),
          onPressed: () {
            widget.isDialogAlert = false;
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class InputTransferencia extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? placeholder;
  final List<TextInputFormatter>? formatadores;
  final IconData? icone;

  const InputTransferencia(
      {required this.controller,
      required this.label,
      this.placeholder,
      this.formatadores,
      this.icone,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 24.0,
          ),
          decoration: InputDecoration(
            icon: icone != null ? Icon(icone) : null,
            labelText: label,
            hintText: placeholder,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: formatadores),
    );
  }
}

class InputPropriedades {
  final String label;
  final String helperText;
  final Icon? icon;
  final TextInputType? tipoTexto;
  final List<TextInputFormatter>? formatadores;

  InputPropriedades(this.label, this.helperText, this.icon, this.tipoTexto,
      this.formatadores);
}

class InputTextfield extends StatelessWidget {
  final InputPropriedades _inputPropriedades;
  const InputTextfield(this._inputPropriedades, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: _inputPropriedades.tipoTexto,
      inputFormatters: _inputPropriedades.formatadores,
      decoration: InputDecoration(
          labelText: _inputPropriedades.label,
          helperText: _inputPropriedades.helperText,
          prefix: _inputPropriedades.icon),
    );
  }
}

class ListaTransferencia extends StatefulWidget {
  ListaTransferencia({Key? key}) : super(key: key);
  late final List<Transferencia> _transferencias = [];

  @override
  State<ListaTransferencia> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: ListView.builder(
          itemCount: widget._transferencias.length,
          itemBuilder: (context, index) {
            final transferencia = widget._transferencias[index];
            return ItemTransferencia(transferencia);
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferencia) {
            if (transferencia != null) {
              setState(() {
                widget._transferencias.add(transferencia);
              });
            }
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final String numeroConta;
  final double valor;

  Transferencia(this.numeroConta, this.valor);

  @override
  String toString() {
    return 'Transferencia{numeroConta: $numeroConta, valor: $valor}';
  }
}
