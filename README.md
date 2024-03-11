# coursepkgs

A nix flake of packages used in various course repositories in DSC at UCSD.

This flake includes the following packages:

- [eldridgejm/automata](http://github.com/eldridgejm/automata)
- [eldridgejm/dsc40graph](http://github.com/eldridgejm/dsc40graph)
- [eldridgejm/gradelib](http://github.com/eldridgejm/gradelib)
- [eldridgejm/dsctex](http://github.com/eldridgejm/dsctex)
- [eldridgejm/removesoln](http://github.com/eldridgejm/removesoln)
- [gradescope/gradescope-utils](http://github.com/gradescope/gradescope-utils)

## Maintenance

To update all packages to use the latest versions, run `nix flake update`.

To update a single package, run `nix flake lock --update-input <input-name>`.
Note that inputs usually end with `-flake`. For example, to update `dsctex`:

```
nix flake lock --update-input dsctex-flake
```
