import 'package:Magnetic.am/value.dart';

class AppRoutePath {
  String _path;

  AppRoutePath(this._path);

  AppRoutePath.home() : _path = '/';

  String get path => _path;

  Uri get uri => () {
        var uri = Uri.parse(url);
        return uri.replace(path: _path);
      }();
}
