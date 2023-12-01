import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pizza_hut/button/iconedbutton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

import '../../bar/defaultappbar.dart';
import '../../bar/pointedbar.dart';
import '../../dialog/paymentdialog.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../pedido/pedido.dart';

class Pix extends StatefulWidget {
  Pix({super.key, this.chavePix});

  String? chavePix;
  int seconds = 30;

  @override
  State<Pix> createState() => _PixState();
}

class _PixState extends State<Pix> {
  late TextEditingController _chavePIXController;
  late TextEditingController _countdownController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // ${widget.chavePix}
    _chavePIXController = TextEditingController(
        text:
            "00020126580014BR.GOV.BCB.PIX0136bd6c459b-b3a0-49a3-b2e0-208ecbf5f73b5204000053039865802BR5925Alexandre da Silva Cardoz6009SAO PAULO610805409000622405200WgCA9f4kXpDzsK7wmtw630453B5");
    _countdownController = TextEditingController(text: '${widget.seconds} seg');
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
          firstIcon: Icons.arrow_back_rounded,
          title: "Pagamento",
          firstOnPressed: () {
            context.pushNamed('Pedido');
          }),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        alignment: Alignment.center,
                        child: QrImageView(
                          data:
                              "00020126580014BR.GOV.BCB.PIX0136bd6c459b-b3a0-49a3-b2e0-208ecbf5f73b5204000053039865802BR5925Alexandre da Silva Cardoz6009SAO PAULO610805409000622405200WgCA9f4kXpDzsK7wmtw630453B5",
                          version: QrVersions.auto,
                          size: 330.0,
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Chave PIX:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _chavePIXController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            contentPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                width: 2.0,
                              ),
                            ),
                          ),
                          enabled: false,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          maxLines: null,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Copiar Chave:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            )),
                        IconedButton(
                          icon: Icons.copy,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          onPressed: _copyToClipboard,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            PointedBar(text: "Verificando Pagamento", exibePoint: false),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Esgota em:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 50,
                      width: 75,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        enabled: false,
                        controller: _countdownController,
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard() {
    String chavePix = _chavePIXController.text;
    Clipboard.setData(ClipboardData(text: chavePix));
    Toast.show(
      'Chave PIX copiada para a área de transferência!',
      duration: 5,
      gravity: Toast.bottom,
      backgroundColor: const Color(0xF7AE1C1E),
    );
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.seconds > 0) {
          widget.seconds--;
          _countdownController.text = '${widget.seconds} seg';
        } else {
          PaymentDialog(
            context,
            "Pagamento",
            "Tempo expirado para efetuar o pegamento do Pedido!",
            "OK",
          );
          _timer.cancel();
          _showAlert();
        }
      });
    });
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tempo Expirado!"),
          content: const Text("O tempo para o pagamento via PIX expirou."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o alerta
                context.pushNamed('Menu');
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
