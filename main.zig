const std = @import("std");

const EXIT_SUCCESS = 0;
const allocator = std.heap.page_allocator;

/// Executes a command using /bin/sh (since zig requires that every field be
/// initialized.
fn execCommand(command: []const u8) void {
    const result = std.process.Child.run(.{
        .allocator = std.heap.page_allocator,
        // slice of anonymous, read only array pointer
        .argv = &[_][]const u8{ "/bin/sh", "-c", command },
    });

    if (result) |r| {
        std.log.debug("{s}\n", .{r.stdout});
    } else |err| {
        std.log.err("Failed to execute: {s}, {any}\n", .{ command, err });
        std.process.exit(1);
    }
}

fn waitInput() void {
    const stdin = std.io.getStdIn().reader();
    std.log.info("Press enter to continue: ", .{});
    _ = stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 5075) catch {};
}

/// This function tries to install Xcode, and if it cannot
/// it runs the xcode installer. I had to work through RunError!RunResult
/// unions that were weird.
fn installXcode() !void {
    const result = try std.process.Child.run(.{
        .allocator = std.heap.page_allocator,
        .argv = &[_][]const u8{ "xcode-select", "-p" },
    });

    if (result.term.Exited == EXIT_SUCCESS) {
        std.log.info("Xcode is already installed\n", .{});
        return;
    }

    std.log.info("Installing xCode Command Line Tools...\n", .{});
    execCommand("xcode-select --install");
    execCommand("sudo xcodebuild -license accept");
}

// Set log level using public decl
pub const log_level: std.log.Level = .debug;

pub fn main() !void {
    std.log.info("Setting up macOS\n\n", .{});

    std.log.info("################################################################################\n", .{});
    std.log.info("Xcode Commandline Tools\n", .{});
    std.log.info("################################################################################\n", .{});
    installXcode() catch {};

    std.log.info("################################################################################\n", .{});
    std.log.info("Homebrew Packages\n", .{});
    std.log.info("################################################################################\n", .{});
    execCommand("scripts/brew.sh");
    std.log.info("Finished installing Homebrew packages\n", .{});

    execCommand("scripts/cli.sh");
    std.log.info("Finished setting up fzf completion\n", .{});

    std.log.info("################################################################################\n", .{});
    std.log.info("MacOS Apps\n", .{});
    std.log.info("################################################################################\n", .{});
    std.log.info("You should already be signed into the App Store to continue\n", .{});
    waitInput();
    execCommand("scripts/setup_mas.sh");
    std.log.info("Finished installing mac apps\n", .{});

    std.log.info("################################################################################\n", .{});
    std.log.info("Tmux Plugins\n", .{});
    std.log.info("################################################################################\n", .{});
    execCommand("scripts/tmux_tpm.sh");
    std.log.info("Finished installing tmux plugins\n", .{});

    std.log.info("################################################################################\n", .{});
    std.log.info("Configuration\n", .{});
    std.log.info("################################################################################\n", .{});
    waitInput();

    execCommand("scripts/osx.sh");
    std.log.info("Finished configuring MacOS defaults. NOTE: restart is needed\n", .{});

    execCommand("setup_stow.sh");
    std.log.info("Finished stowing dotfiles\n", .{});

    std.process.exit(0);
}
