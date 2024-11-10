# Upstream: https://github.com/OpenIntelWireless/itlwm/releases

{ lib }: rec {
  latest = v2_3_0;

  # v2_2_0_alpha = {
  #   canonicalVersion = "v2.2.0-alpha";
  #   url = "https://github.com/OpenIntelWireless/itlwm/releases/download/v2.2.0-alpha/itlwm-v2.2.0-DEBUG-alpha-ee56708.zip";
  #   sha256 = "sha256-AIKVSJrD2+tW9BboQQ5MdoR+XEVoATZt7Qezlkp0JXs=";
  # };

  v2_3_0 = let
    canonicalVersion = "v2.3.0";
  in {
    inherit canonicalVersion;
    url = "https://github.com/OpenIntelWireless/itlwm/releases/download/${canonicalVersion}/itlwm_${canonicalVersion}_stable.kext.zip";
    sha256 = "sha256-TUDUdr7d2UCsGquJkV/Iecbj3HYoA7jeMhknd5Qfmiw=";
  };

  v2_2_0 = let
    canonicalVersion = "v2.2.0";
  in {
    inherit canonicalVersion;
    url = "https://github.com/OpenIntelWireless/itlwm/releases/download/${canonicalVersion}/itlwm_${canonicalVersion}_stable.kext.zip";
    sha256 = "sha256-QwoIj9JcCKxE/BQ2ebpaFpQUAy0OujcUAfd96FOY0io=";
  };

  v2_1_0 = let
    canonicalVersion = "v2.1.0";
  in {
    inherit canonicalVersion;
    url = "https://github.com/OpenIntelWireless/itlwm/releases/download/${canonicalVersion}/itlwm_${canonicalVersion}_stable.kext.zip";
    sha256 = "sha256-6MzyYWCohJiLNzFYpnCh5GkIQPUh6vw6iSJv/WVnfmE=";
  };
}
