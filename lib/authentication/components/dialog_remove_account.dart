import 'package:flutter/material.dart';
import 'package:flutter_listin/_core/constants/listin_keys.dart';

import '../services/auth_service.dart';

showRemoveAccountPasswordConfirmationDialog({
  required BuildContext context,
  required String email,
}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController senhaConfirmacaoController =
          TextEditingController();
      return AlertDialog(
        title: Text("Deseja remover a conta com o e-mail $email?"),
        content: SizedBox(
          height: 175,
          child: Column(
            children: [
              const Text(
                  "Para confirmar a remoção da conta, insira sua senha:"),
              TextFormField(
                key: const ValueKey(ListinKeys.dialogRemoveAccountPassTextField),
                controller: senhaConfirmacaoController,
                obscureText: true,
                decoration: const InputDecoration(label: Text("Senha")),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            key: const ValueKey(ListinKeys.dialogRemoveAccountButton),
            onPressed: () {
              AuthService()
                  .removeAccount(senha: senhaConfirmacaoController.text)
                  .then((String? erro) {
                if (erro == null) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text("EXCLUIR CONTA"),
          )
        ],
      );
    },
  );
}
