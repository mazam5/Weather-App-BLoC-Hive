part of 'internet_cubit.dart';

enum ConnectionStatus { connected, disconnected }

class InternetStatus {
  final ConnectionStatus status;
  const InternetStatus(this.status);
}
