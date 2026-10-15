# data/

Nothing in this folder is tracked by git (see `.gitignore`).

Expected input: hyperspectral cubes in ENVI format (`.dat` + `.hdr`), plus a
dark reference cube taken with the same settings (`dpath` in
`src/sparse/MainScript.m`). Bands 20–53 are used for the main camera.
Lab, rooftop, outdoor and SnapScan scenes were used in the paper.

The original scripts had absolute paths to the author's machines. These were
replaced with relative placeholders that start with `.\data\...`, so the
simplest set-up is to copy (or symlink) your data here, keeping the same
sub-folder names, and run scripts from the repository root. You can also just
edit the path variables at the top of each script.
