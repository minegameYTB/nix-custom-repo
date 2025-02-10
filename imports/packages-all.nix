{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        sshrm = pkgs.callPackage ../pkgs/cli/sshrm {};
        fhsEnv-dev = pkgs.callPackage ../pkgs/cli/fhsEnv-dev {};
        GLFfetch = pkgs.callPackage ../pkgs/cli/GLFfetch {};
        GLFfetch-GLFos = pkgs.callPackage ../pkgs/cli/GLFfetch { glfIcon = "GLFos"; };
        hello = pkgs.callPackage ../pkgs/misc/hello {};
        ### Add new pkgs here
      };
    };
}
