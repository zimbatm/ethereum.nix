{
  fetchFromGitHub,
  lib,
  poetry2nix,
}:
poetry2nix.mkPoetryApplication rec {
  pname = "woke";
  version = "3.2.0";

  projectDir = fetchFromGitHub {
    owner = "Ackee-Blockchain";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JI1jjGiBLZtDyvM11t4nxiLimAAXRDks04LBhzz+tmk=";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Ackee-Blockchain/woke";
    description = "Woke is a Python-based development and testing framework for Solidity.";
    license = licenses.isc;
    platforms = ["x86_64-linux"];
  };
}
