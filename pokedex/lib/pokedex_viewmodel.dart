import 'package:flutter/material.dart';
import 'package:pokedex/core/bases/failure.dart';
import 'package:pokedex/core/helpers/network_states.dart';
import 'package:pokedex/core/network/network_info.dart';
import 'package:pokedex/datasource/poke_remote_datasource.dart';
import 'package:pokedex/models/pokemon_response.dart';
import 'package:pokedex/repository/pokedex_repository.dart';

import 'core/network/network_connection_failure.dart';

class PokeDexViewModel extends ChangeNotifier{
  Failure? _pokemonFailureResponse;
  PokemonResponse? _pokemonResponse;
  List<Pokemon> _pokeList = [];
  List<Pokemon> get pokeList => _pokeList.toList();

  updatePokeList() {
    _pokeList.addAll(_pokemonResponse?.results ?? []);
    notifyListeners();
  }

  NetworkState _networkState = NetworkState.loading;
  NetworkState get networkState => _networkState;
  void setNetworkState(NetworkState state) {
    _networkState = state;
    notifyListeners();
  }


  int _listOffset = 0;
  int _pageCount = 0;
  final int listLength = 30;
  updateListOffset() {
    _pageCount++;
    _listOffset = listLength * _pageCount;
  }

  Future<void> fetchPokeList() async {
    _pokemonFailureResponse = null;
    _pokemonResponse = null;
    PokeRemoteDatasource remoteDatasource = PokeRemoteDatasource();
    NetworkInfo networkInfo = NetworkInfoImpl();
    PokeRepository repository = PokeRepository(networkInfo: networkInfo, remoteDataSource: remoteDatasource);
   // setNetworkState(NetworkState.loading);
    final response = await repository.fetchPokeMons(_listOffset, listLength);
    if (response.successResponse != null) {
      _pokemonResponse = response.successResponse;
      setNetworkState(NetworkState.success);
      updatePokeList();
    } else if (response.failureResponse != null) {
     if (response.failureResponse == NetworkConnectionFailure()) {
       setNetworkState(NetworkState.no_internet);
      } else {
       setNetworkState(NetworkState.other_failure);
      }
     _pokemonFailureResponse = response.failureResponse;
    }
  }

  resetPokeList() {
    _pokeList.clear();
    _listOffset = 0;
    _pageCount = 0;
    _networkState = NetworkState.loading;
  }
}