{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = with pkgs; {
        sshrm = callPackage ../pkgs/cli/sshrm {};
        fhsEnv-dev = callPackage ../pkgs/cli/fhsEnv-dev {};
        GLFfetch = callPackage ../pkgs/cli/GLFfetch {};
        hello = callPackage ../pkgs/misc/hello {};
        ### Add new pkgs here
      };
    };
}
