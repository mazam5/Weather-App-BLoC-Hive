import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetStatus> {
  InternetCubit() : super(const InternetStatus(ConnectionStatus.disconnected));

  final Connectivity _connectivity = Connectivity();

  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    updateConnectionStatus(connectionResult.first);
  }

  void updateConnectionStatus(ConnectivityResult connectionResult) {
    var connectionStatus = _getStatus(connectionResult);
    emit(InternetStatus(connectionStatus));
  }

  ConnectionStatus _getStatus(ConnectivityResult connectionResult) {
    if (connectionResult == ConnectivityResult.mobile ||
        connectionResult == ConnectivityResult.wifi) {
      return ConnectionStatus.connected;
    } else {
      return ConnectionStatus.disconnected;
    }
  }

  Stream<InternetStatus> get internetStatus =>
      _connectivity.onConnectivityChanged
          .map((event) => _getStatus(event.first))
          .map((event) => InternetStatus(event));
}
