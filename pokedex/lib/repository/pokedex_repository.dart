import 'package:pokedex/core/bases/base_api_response.dart';
import 'package:pokedex/core/bases/exception.dart';
import 'package:pokedex/core/bases/failure.dart';
import 'package:pokedex/core/network/network_info.dart';
import 'package:pokedex/datasource/poke_remote_datasource.dart';

import 'package:pokedex/models/pokemon_response.dart';

import '../core/network/network_connection_failure.dart';

class PokeRepository {
  final NetworkInfo networkInfo;
  final PokeRemoteDatasource remoteDataSource;

  PokeRepository({
    required this.networkInfo,
    required this.remoteDataSource
});
  Future<BaseAPIResponse<Failure, PokemonResponse>> fetchPokeMons(int offset, int listLen) async {
    final isNetworkConnected = await networkInfo.isConnected;
    final response = BaseAPIResponse<Failure, PokemonResponse>();

    try {
      if (isNetworkConnected) {
        final remoteResponse = await remoteDataSource.getPokeMonList(offset, listLen);
        response.setSuccessResponse(remoteResponse);
      } else {
        print('network not connected!');
        response.setFailureResponse(NetworkConnectionFailure());
      }
    } on ServerException catch (e) {
      response.setFailureResponse(ServerFailure(message: e.message));
    }

    return response;
  }
}