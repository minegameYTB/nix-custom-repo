{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        sshrm = pkgs.callPackage ../pkgs/cli/sshrm {};
        hello = pkgs.callPackage ../pkgs/misc/hello {};
        webapp-manager = pkgs.callPackage ../pkgs/applications/web/webapp-manager {};
        ### Add new pkgs here
      };
    };
}
