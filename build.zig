const std = @import("std");

pub fn build(b: *std.Build) void {
    // -------------------------------------------//
    // Define target                              //
    // -------------------------------------------//
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
        .cpu_features_add = std.Target.arm.featureSet(&[_]std.Target.arm.Feature{
            std.Target.arm.Feature.thumb_mode,
            std.Target.arm.Feature.v7em,
        }),
        .os_tag = .freestanding,
        .abi = .eabihf,
        .ofmt = .elf,
    });

    // -------------------------------------------//
    // Define optimization                        //
    // -------------------------------------------//
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .Debug });

    // -------------------------------------------//
    // Define module                              //
    // -------------------------------------------//
    const module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });
    module.addAssemblyFile(b.path("startup_f401.s"));

    // -------------------------------------------//
    // Define executable                          //
    // -------------------------------------------//
    const exe = b.addExecutable(.{
        .name = "stm32f401re.elf",
        .root_module = module,
        .linkage = .static,
    });
    exe.link_gc_sections = true;
    exe.link_data_sections = true;
    exe.link_function_sections = true;
    exe.setLinkerScript(b.path("linker.ld")); // You must provide this

    b.installArtifact(exe);
}
