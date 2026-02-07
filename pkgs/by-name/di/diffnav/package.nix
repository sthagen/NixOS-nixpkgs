{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  delta,
}:

buildGoModule (finalAttrs: {
  pname = "diffnav";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "diffnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2CAvZyBcWlaTHcDqKlGYjFiZJm9UcwGS3YQpeaphKTE=";
  };

  vendorHash = "sha256-FA58Rd+tEiyArDCeKsekpxkM+i8z/KlO3GLzkonSKVM=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];
  postInstall = ''
    wrapProgram $out/bin/diffnav \
      --prefix PATH : ${lib.makeBinPath [ delta ]}
  '';

  meta = {
    changelog = "https://github.com/dlvhdr/diffnav/releases/tag/${finalAttrs.src.rev}";
    description = "Git diff pager based on delta but with a file tree, à la GitHub";
    homepage = "https://github.com/dlvhdr/diffnav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "diffnav";
  };
})
