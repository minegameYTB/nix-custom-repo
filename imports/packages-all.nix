{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        sshrm = pkgs.callPackage ../pkgs/sshrm {};
        ### Add new pkgs here
      };
    };
}
