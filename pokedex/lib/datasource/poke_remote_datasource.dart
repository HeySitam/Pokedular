import 'package:dio/dio.dart';

import '../core/bases/exception.dart';
import '../models/pokemon_response.dart';

class PokeRemoteDatasource {
  Future<PokemonResponse> getPokeMonList(int offset, int listLen) async {
    final dio = Dio();
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$listLen');
      return PokemonResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException("${e.message}");
    }
  }
}