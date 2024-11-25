{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        sshrm = pkgs.callPackage ../pkgs/cli/sshrm {};
        hello = pkgs.callPackage ../pkgs/misc/hello {};
        ### Add new pkgs here
      };
    };
}
