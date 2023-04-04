{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "tx-fuzz";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "MariusVanDerWijden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1GaumY1mKB1r3ClHVXZSwv02ChRpO1BuFiGSaq5j35k=";
  };

  vendorSha256 = "sha256-Tugu+UevDgZ/duJTJAA0prcnieW34UUfxk3uPRCGc9s=";

  buildInputs = [];

  subPackages = ["."];

  modBuildPhase = '''';

  meta = with lib; {
    homepage = "https://github.com/MariusVanDerWijden/tx-fuzz";
    description = "TX-Fuzz is a package containing helpful functions to create random transactions.";
    platforms = ["x86_64-linux"];
  };
}
