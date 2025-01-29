{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        sshrm = pkgs.callPackage ../pkgs/cli/sshrm {};
        fhsEnv-dev = pkgs.callPackage ../pkgs/cli/fhsEnv-dev {};
        hello = pkgs.callPackage ../pkgs/misc/hello {};
        ### Add new pkgs here
      };
    };
}
