import 'package:flutter/material.dart';
import '../models/familia.dart';
import '../data/familia_repository.dart';

class FamiliaPage extends StatefulWidget {
  const FamiliaPage({super.key});

  @override
  State<FamiliaPage> createState() => _FamiliaPageState();
}

class _FamiliaPageState extends State<FamiliaPage> {
  List<Familia> familias = [];

  final TextEditingController responsavelCtrl = TextEditingController();
  final TextEditingController enderecoCtrl = TextEditingController();
  final TextEditingController membrosCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    familias = await FamiliaRepository.buscarTodos();
    setState(() {});
  }

  void limparCampos() {
    responsavelCtrl.clear();
    enderecoCtrl.clear();
    membrosCtrl.clear();
  }

  void adicionarOuEditar({Familia? familia}) {
    if (familia != null) {
      responsavelCtrl.text = familia.responsavel;
      enderecoCtrl.text = familia.endereco;
      membrosCtrl.text = familia.membros.toString();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              familia == null ? 'Adicionar Família' : 'Editar Família',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: responsavelCtrl,
              decoration: const InputDecoration(
                labelText: 'Responsável',
                filled: true,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: enderecoCtrl,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                filled: true,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: membrosCtrl,
              decoration: const InputDecoration(
                labelText: 'Número de membros',
                filled: true,
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  if (responsavelCtrl.text.isEmpty ||
                      enderecoCtrl.text.isEmpty ||
                      membrosCtrl.text.isEmpty) return;

                  if (familia == null) {
                    await FamiliaRepository.inserir(
                      Familia(
                        responsavel: responsavelCtrl.text,
                        endereco: enderecoCtrl.text,
                        membros: int.parse(membrosCtrl.text),
                      ),
                    );
                  } else {
                    familia.responsavel = responsavelCtrl.text;
                    familia.endereco = enderecoCtrl.text;
                    familia.membros = int.parse(membrosCtrl.text);

                    await FamiliaRepository.atualizar(familia);
                  }

                  await carregarDados();
                  limparCampos();
                  Navigator.pop(context);
                },
                child: const Text('Salvar', style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void remover(Familia familia) async {
    await FamiliaRepository.remover(familia.id!);
    await carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Famílias')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => adicionarOuEditar(),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
      body: familias.isEmpty
          ? const Center(child: Text('Nenhuma família cadastrada.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: familias.length,
              itemBuilder: (_, index) {
                final f = familias[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      f.responsavel,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Endereço: ${f.endereco}'),
                        Text('Membros: ${f.membros}'),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => adicionarOuEditar(familia: f),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => remover(f),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
