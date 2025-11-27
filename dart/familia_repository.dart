import 'db.dart';
import '../models/familia.dart';

class FamiliaRepository {
  static Future<List<Familia>> buscarTodos() async {
    final conn = await Database.connect();
    final results = await conn.query(
      'SELECT id, responsavel, endereco, membros FROM familias',
    );
    await conn.close();

    return results.map((row) {
      return Familia(
        id: row['id'],
        responsavel: row['responsavel'],
        endereco: row['endereco'],
        membros: row['membros'],
      );
    }).toList();
  }

  static Future<void> inserir(Familia familia) async {
    final conn = await Database.connect();
    await conn.query(
      'INSERT INTO familias (responsavel, endereco, membros) VALUES (?, ?, ?)',
      [familia.responsavel, familia.endereco, familia.membros],
    );
    await conn.close();
  }

  static Future<void> atualizar(Familia familia) async {
    final conn = await Database.connect();
    await conn.query(
      'UPDATE familias SET responsavel=?, endereco=?, membros=? WHERE id=?',
      [
        familia.responsavel,
        familia.endereco,
        familia.membros,
        familia.id,
      ],
    );
    await conn.close();
  }

  static Future<void> remover(int id) async {
    final conn = await Database.connect();
    await conn.query('DELETE FROM familias WHERE id=?', [id]);
    await conn.close();
  }
}
