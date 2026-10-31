{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/myume/nixie";
        branches.main.name = "main";
      }
    ];
    exporter.port = 4243;
  };
}
