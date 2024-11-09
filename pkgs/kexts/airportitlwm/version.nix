# Upstream: https://github.com/OpenIntelWireless/itlwm/releases

{ lib }: rec {
  latest = v2_3_0;

  default = v2_3_0;

  # v2_2_0_alpha = {
  #   canonicalVersion = "v2.2.0-alpha";
  #   supportedOS = [ "BigSur" "Catalina" "Monterey" "Ventura" ];
  #   mkUrl = osVer: "https://github.com/OpenIntelWireless/itlwm/releases/download/v2.2.0-alpha/AirportItlwm-${if osVer == "BigSur" then "Big_Sur" else osVer}-v2.2.0-DEBUG-alpha-ee56708.zip";
  #   BigSur = "sha256-nPROo6iC0kybGRXdoaoGxzJPLcmxNT40d0qzxSc2ZCg=";
  #   Catalina = "sha256-ffz0g7a5J09Iuxi7vbyGyeuj9Ykx8hSym+w0Xt2e8wo=";
  #   Monterey = "sha256-xEfMfU3r4RSRikEuq8SjdF4fVbtpNlnbYfvW6OAn0nk=";
  #   Ventura = "sha256-Dckhcqx/aKc2eVcXV+cQMmrbHkX5S5GlmoQ8y7iGx6M=";
  # };

  v2_3_0 = let
    canonicalVersion = "v2.3.0";
  in {
    inherit canonicalVersion;
    supportedOS = [ "BigSur" "Monterey" "Ventura" "Sonoma14.0" "Sonoma14.4" ];
    mkUrl = osVer: "https://github.com/OpenIntelWireless/itlwm/releases/download/${canonicalVersion}/AirportItlwm_${canonicalVersion}_stable_${osVer}.kext.zip";
    BigSur = "sha256-DYn+T1FQI6gc6ha7w1QNLOstDcMSzG8QUAOOR/6jH9w=";
    Monterey = "sha256-2kp0aLuS++hzUT4M0NA302f2UFEznXO3JtTEC2Fn+SM=";
    Ventura = "sha256-fqGTB++a4ImR2RHm8d5Z5oJETiHbzWNCteCgN/Gchg4=";
    "Sonoma14.0" = "sha256-15X8WETpEm9DJ8S+XOrpKX6/igl3N3ooxKJDRmQ2Cbs=";
    "Sonoma14.4" = "sha256-fvEqgDfrm8eVgow0j0+gcouK3leqCYSwN4Fu+RwtURk=";
  };

  v2_2_0 = let
    canonicalVersion = "v2.2.0";
  in {
    inherit canonicalVersion;
    supportedOS = [ "BigSur" "Monterey" "Ventura" ];
    mkUrl = osVer: "https://github.com/OpenIntelWireless/itlwm/releases/download/${canonicalVersion}/AirportItlwm_${canonicalVersion}_stable_${osVer}.kext.zip";
    BigSur = "sha256-wJzyIWAEUZyNIQwVzha+zFlStEysrwrIxnUT8e4SJdg=";
    Monterey = "sha256-vBffrZPy59fXgGQP0mIZ4nwa/qKYss6OBeQyjCSTH70=";
    Ventura = "sha256-101gciXPK2xf/fhCToNT42LqwkFjn6oGNgEHC3Is6rQ=";
  };

  v2_1_0 = let
    canonicalVersion = "v2.1.0";
  in {
    inherit canonicalVersion;
    supportedOS = [ "BigSur" "Monterey" ];
    mkUrl = osVer: "https://github.com/OpenIntelWireless/itlwm/releases/download/${canonicalVersion}/AirportItlwm_${canonicalVersion}_stable_${osVer}.kext.zip";
    BigSur = "sha256-F6xjLHWF0mAwKpdYbXjM05E8qZoWTmg3U/6NHGnF5i8=";
    Monterey = "sha256-D/xkAKHsuYCLqz43E4OhcsfDbSzK57J/FUcovuPOiHM=";
  };
}
