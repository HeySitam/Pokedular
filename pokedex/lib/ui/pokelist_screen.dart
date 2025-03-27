import 'dart:developer';

import 'package:pokedex/core/helpers/network_states.dart';
import 'package:pokedex/core/network/network_info.dart';
import 'package:pokedex/pokedex_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/core/routes/pokedex_route.dart';
import 'package:pokedex/datasource/poke_remote_datasource.dart';
import 'package:pokedex/models/pokemon_response.dart';
import 'package:pokedex/ui/poke_details_screen.dart';
import 'package:pokedex/utils/constants.dart';
import 'package:provider/provider.dart';

class PokelistScreen extends StatefulWidget {
  const PokelistScreen({super.key});

  @override
  State<PokelistScreen> createState() => _PokelistScreenState();
}

class _PokelistScreenState extends State<PokelistScreen> {
  ScrollController _scrollController = ScrollController();
  late PokeDexViewModel pokeDexViewModel;
  @override
  void initState() {
    pokeDexViewModel =
        Provider.of<PokeDexViewModel>(context, listen: false);
    pokeDexViewModel.fetchPokeList();
    _scrollController.addListener(() {
      // Check if the scroll has reached the bottom
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (pokeDexViewModel.networkState != NetworkState.loading ||
            pokeDexViewModel.networkState != NetworkState.other_failure ||
            pokeDexViewModel.networkState != NetworkState.no_internet) {
          pokeDexViewModel.updateListOffset();
          pokeDexViewModel.setNetworkState(NetworkState.list_loading);
          pokeDexViewModel.fetchPokeList();
        }
      }
    });
    super.initState();
  }

  Future<void> _handlePullToRefresh() async {
    pokeDexViewModel.resetPokeList();
  //  pokeDexViewModel.setNetworkState(NetworkState.loading);
    pokeDexViewModel.fetchPokeList();
  }

  _retryOnErrorAtTheTimeOfListFetching() async {
    NetworkInfo networkInfo = NetworkInfoImpl();
    if(await networkInfo.isConnected) {
      pokeDexViewModel.setNetworkState(NetworkState.idle);
    }
    if(pokeDexViewModel.networkState == NetworkState.no_internet) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet!"),
          content: const Icon(Icons.signal_wifi_connected_no_internet_4, size: 100,),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("CLOSE"))
          ],
        );
      });
    } else {
      pokeDexViewModel.fetchPokeList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PokeDex"),
        centerTitle: true,
      ),
      body: Consumer<PokeDexViewModel>(builder: (context, pokeDexVM, child) {
        log("${pokeDexVM.networkState}");
        bool isLoadingMoreList =
            pokeDexVM.networkState == NetworkState.list_loading;
        bool isGettingErrorWhenPokeListIsNotEmpty = (pokeDexVM.networkState == NetworkState.no_internet ||
            pokeDexVM.networkState ==
                NetworkState.other_failure) &&
            pokeDexVM.pokeList.isNotEmpty;
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: pokeDexVM.networkState == NetworkState.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                onRefresh: _handlePullToRefresh,
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: isGettingErrorWhenPokeListIsNotEmpty || isLoadingMoreList
                        ? pokeDexVM.pokeList.length + 1
                        : pokeDexVM.pokeList.length,
                    itemBuilder: (context, pos) {
                      bool isGetErrorOnMoreListLoading =
                          isGettingErrorWhenPokeListIsNotEmpty && pos == pokeDexVM.pokeList.length;
                      if (isLoadingMoreList && pos == pokeDexVM.pokeList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (isGetErrorOnMoreListLoading) {
                        return InkWell(
                          onTap: _retryOnErrorAtTheTimeOfListFetching,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.lock_reset,
                                size: 32,
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          leading: Hero(
                            tag: pokeDexVM.pokeList[pos].name ?? "PokeMon",
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                "${AppConstants.pokeBaseImageUrl}/${pos + 1}.png",
                              ),
                            ),
                          ),
                          title: Text(pokeDexVM.pokeList[pos].name ?? "PokeMon"),
                          tileColor: Colors.black12,
                          onTap: () {
                            context.goNamed("pokedetails", pathParameters: {
                              'pokeName':
                                  pokeDexVM.pokeList[pos].name ?? "PokeMon",
                              'pokeImgUrl':
                                  "${AppConstants.pokeBaseImageUrl}/${pos + 1}.png"
                            });
                          },
                        ),
                      );
                    }),
              ),
        );
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
