import 'package:pokedex/core/bases/failure.dart';

class NetworkConnectionFailure extends Failure{
  static final NetworkConnectionFailure _singleton = NetworkConnectionFailure._internal(message: "No Network Found!");
  NetworkConnectionFailure._internal({super.message});

  factory NetworkConnectionFailure() {
    return _singleton;
  }

  static bool isNoNetworkError(Failure failure){
    return failure == NetworkConnectionFailure();
  }

  @override
  List<Object?> get props => [message];
}