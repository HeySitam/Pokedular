class PokemonResponse {
  final List<Pokemon>? results;
  final String? next;
  final String? previous;
  PokemonResponse({
    this.results,
    this.next,
    this.previous
  });

  factory PokemonResponse.fromJson(Map<String, dynamic> json) {
    return PokemonResponse(
      results: json['results'] != null
          ? List<Pokemon>.from(json['results'].map((data) => Pokemon.fromJson(data)))
          : null,
      next: json['next'],
      previous: json["previous"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results?.map((pokemon) => pokemon.toJson()).toList(),
    };
  }
}

class Pokemon {
  final String? name;
  final String? url;

  Pokemon({
    this.name,
    this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}