{
  lib,
  buildLinux,
  fetchurl,
  kernelPatches ? [ ],
  structuredExtraConfig ? { },
  extraMeta ? { },
  argsOverride ? { },
  ...
}@args:

let
  version = "5.15.177-rt83"; # updated by ./update-rt.sh
  branch = lib.versions.majorMinor version;
  kversion = builtins.elemAt (lib.splitString "-" version) 0;
in
buildLinux (
  args
  // {
    inherit version;
    pname = "linux-rt";

    # modDirVersion needs a patch number, change X.Y-rtZ to X.Y.0-rtZ.
    modDirVersion =
      if (builtins.match "[^.]*[.][^.]*-.*" version) == null then
        version
      else
        lib.replaceStrings [ "-" ] [ ".0-" ] version;

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
      sha256 = "1q56w3lqwi3ynny6z7siqzv3h8nryksyw70r3fhghca2il4bi7pa";
    };

    kernelPatches =
      let
        rt-patch = {
          name = "rt";
          patch = fetchurl {
            url = "mirror://kernel/linux/kernel/projects/rt/${branch}/older/patch-${version}.patch.xz";
            sha256 = "1rc0cbc5jkgr3q3q2syqidak744lxcq3f5zdq6si2rsfxjz45www";
          };
        };
      in
      [ rt-patch ] ++ kernelPatches;

    structuredExtraConfig =
      with lib.kernel;
      {
        PREEMPT_RT = yes;
        # Fix error: unused option: PREEMPT_RT.
        EXPERT = yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt)
        # Fix error: option not set correctly: PREEMPT_VOLUNTARY (wanted 'y', got 'n').
        PREEMPT_VOLUNTARY = lib.mkForce no; # PREEMPT_RT deselects it.
        # Fix error: unused option: RT_GROUP_SCHED.
        RT_GROUP_SCHED = lib.mkForce (option no); # Removed by sched-disable-rt-group-sched-on-rt.patch.
      }
      // structuredExtraConfig;

    extraMeta = extraMeta // {
      inherit branch;
    };
  }
  // argsOverride
)
