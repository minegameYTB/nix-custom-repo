{ stdenv, fetchzip }:

 stdenv.mkDerivation rec {
   pname = "hello";
   version = "2.12.1";

   src = fetchzip {
   	 url = "https://ftp.gnu.org/gnu/${pname}/${pname}-${version}.tar.gz";
   	 sha256 = "sha256-1kJjhtlsAkpNB7f6tZEs+dbKd8z7KoNHyDHEJ0tmhnc=";
   };
 }
