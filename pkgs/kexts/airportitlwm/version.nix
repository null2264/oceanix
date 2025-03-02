# Upstream: https://github.com/OpenIntelWireless/itlwm/releases

{ lib }:

rec {
  latest = v2_3_0;

  v2_3_0 = {
    canonicalVersion = "v2.3.0";
    os = {
      BigSur = "sha256-jSoyovOy4XGnBcVwQbh6TPSGuX+4HS/hKBrzBGNHaSc=";
      Monterey = "sha256-/rrnbg1Rhd5X9CMEjzrsd9ehgxzqHfmaEEopuTbLwFY=";
      Ventura = "sha256-RJ3hhhZCNgsf9PaoeF+ld43qFXSuDBZxJgInzZ4Jhik=";
      "Sonoma14.0" = "sha256-KPlvE3QBylg61Tfek+DZbIHriNs8U3HWQ108zx7P7Xk=";
      "Sonoma14.4" = "sha256-n4kxR5lmy1T3q264jtDnkjR/blxhMGnGOX9wyoXxCJs=";
    };
  };

  v2_2_0 = {
    canonicalVersion = "v2.2.0";
    os = {
      BigSur = "sha256-KrUboZ953crx0vy5qmbqdxzWRuGXnniwuQKN2WD20Z8=";
      Monterey = "sha256-1tZ/bUrdDDcYedAaKXFWfW8tXM9M5h4vxGZnbR+I+BA=";
      Ventura = "sha256-4EfOZemFUWzmn2ADtvYo4jj+HZ8hAje7Lxjhj2LVUrU=";
    };
  };

  v2_1_0 = {
    canonicalVersion = "v2.1.0";
    os = {
      BigSur = "sha256-F6xjLHWF0mAwKpdYbXjM05E8qZoWTmg3U/6NHGnF5i8=";
      Monterey = "sha256-D/xkAKHsuYCLqz43E4OhcsfDbSzK57J/FUcovuPOiHM=";
    };
  };
}
