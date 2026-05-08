abstract class NetworkInfo {
  bool get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  bool get isConnected => true;
}
