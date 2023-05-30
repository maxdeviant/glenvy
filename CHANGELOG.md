# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2023-05-30

### Added

- Added support for JavaScript targets.

### Changed

- `error.Io` now contains an error message instead of a `file.Reason`.

## [0.3.0] - 2023-05-30

### Added

- `glenvy/env`
  - Added `get_string` for reading environment variables as `String`s.
  - Added `get_bool` for reading environment variables as `Bool`s.

### Changed

- `glenvy/env`
  - `get` is now a generic function that accepts a parser. Use `get_string` if you want access to the environment variable value as a `String`.

## [0.2.0] - 2023-05-30

### Added

- Added `glenvy/env` for reading strongly-typed environment variables.

## [0.1.0] - 2023-05-29

- Initial release.

[unreleased]: https://github.com/maxdeviant/glenvy/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/maxdeviant/glenvy/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/maxdeviant/glenvy/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/maxdeviant/glenvy/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/maxdeviant/glenvy/compare/c28c7de...v0.1.0
