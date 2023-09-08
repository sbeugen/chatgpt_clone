enum Routes {
  chat(path: "/"),
  settings(path: "/settings");

  const Routes({required this.path});

  final String path;
}
