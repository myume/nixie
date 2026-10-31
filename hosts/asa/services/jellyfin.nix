{
  selfhosted.services.jellyfin = {
    port = 8096;
  };

  services.jellyfin = {
    enable = true;
    user = "yum";
  };
}
