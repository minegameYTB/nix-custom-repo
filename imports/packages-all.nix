{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        sshrm = pkgs.callPackage ../pkgs/cli/sshrm {};
        ### Add new pkgs here
      };
    };
}
