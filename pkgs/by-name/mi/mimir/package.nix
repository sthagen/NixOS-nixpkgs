{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
buildGoModule rec {
  pname = "mimir";
  version = "2.16.1";

  src = fetchFromGitHub {
    rev = "mimir-${version}";
    owner = "grafana";
    repo = "mimir";
    hash = "sha256-+GFsWBjZHxRe3a2/ZT0zkoRXDTR4qopTUcU5Fx9t5xA=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/mimir"
    "cmd/mimirtool"
  ]
  ++ (map (pathName: "tools/${pathName}") [
    "compaction-planner"
    "copyblocks"
    "copyprefix"
    "delete-objects"
    "list-deduplicated-blocks"
    "listblocks"
    "mark-blocks"
    "undelete-blocks"
  ]);

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "mimir-([0-9.]+)"
      ];
    };
    tests = {
      inherit (nixosTests) mimir;
    };
  };

  ldflags =
    let
      t = "github.com/grafana/mimir/pkg/util/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
    ];

  meta = with lib; {
    description = "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus. ";
    homepage = "https://github.com/grafana/mimir";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      happysalada
      bryanhonof
      adamcstephens
    ];
  };
}
