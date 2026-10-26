# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `executable_path` and `executable_folder`: the running program's own path (GetModuleFileNameW), so a program finds files installed beside it whatever folder it was started from or found through PATH (simple_bible's `bible` command line, 2026-10-26). The test app checks it with a plain comparison, since `check` is vacuous in finalized builds.

### Changed
- Post-session update 2025-12-08 20:52
- Post-session update 2025-12-08 20:45
- Post-session update 2025-12-08 20:16
- Inline C code into Eiffel class 
- Testing config updates, AutoTest fixes, .gitignore cleanup
- Migrate to simple_testing library
- Add GitHub Pages documentation
- Initial implementation: Environment variable library
- first commit
- first commit

## [1.0.0] - 2025-12-08

### Added
- Initial release
- Core functionality implemented
- Test suite with comprehensive coverage
- Documentation and examples

[Unreleased]: https://github.com/simple-eiffel/simple_env/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/simple-eiffel/simple_env/releases/tag/v1.0.0
