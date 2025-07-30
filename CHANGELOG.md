# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.1] - 2025-07-29

### Changed

- Upgraded dependencies.

## [2.0.0] - 2025-05-03

### Changed

- `glenvy/env`
  - Renamed `get` to `parse`.
  - Renamed `get_all` to `all`.
  - Renamed `get_bool` to `bool`.
  - Renamed `get_float` to `float`.
  - Renamed `get_int` to `int`.
  - Renamed `get_string` to `string`.

## [1.2.0] - 2024-12-05

### Changed

- Upgraded `gleam_erlang` to v0.33.0.

## [1.1.0] - 2024-11-21

### Changed

- `glenvy/env`
  - The parsing function passed to `get` now accepts any error type in the `Result`.

## [1.0.1] - 2024-07-31

### Changed

- Upgraded `simplifile` to v2.0.1.

## [1.0.0] - 2024-04-29

### Added

- `glenvy/env`
  - Added an `Error` type.
  - Added `get_all` for retrieving all of the available environment variables ([#5](https://github.com/maxdeviant/glenvy/issues/5)).
- `glenvy/dotenv`
  - Added `read_from` for reading the contents of a `.env` file into memory ([#4](https://github.com/maxdeviant/glenvy/issues/4)).

### Changed

- `glenvy/env`
  - `get_string` now returns `Result(String, Error)` instead of `Result(String, Nil)`.
  - `get` now returns `Result(a, Error)` instead of `Result(a, Nil)`.
  - `get_int` now returns `Result(Int, Error)` instead of `Result(Int, Nil)`.
  - `get_float` now returns `Result(Float, Error)` instead of `Result(Float, Nil)`.
  - `get_bool` now returns `Result(Bool, Error)` instead of `Result(Bool, Nil)`.
- Moved `glenvy/error.{type Error}` to `glenvy/dotenv.{type Error}`.
- Changed `glenvy/dotenv.{Io}` to contain a `simplifile.FileError` instead of a `String`.

## [0.6.1] - 2024-04-13

### Changed

- Tweaked the package description.

## [0.6.0] - 2024-04-13

### Added

- `glenvy/dotenv`
  - Added support for values containing `=` without needing to quote them (e.g., `KEY=aGVsbG8=`).
    - Any `=`s on a line after the first one are now treated as part of the value.

## [0.5.1] - 2024-01-30

### Changed

- Expanded Gleam `stdlib` range.

## [0.5.0] - 2024-01-25

### Changed

- Upgraded Gleam `stdlib` to v0.34.
- Replaced `Map` with `Dict`.

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

[unreleased]: https://github.com/maxdeviant/glenvy/compare/v2.0.1...HEAD
[2.0.1]: https://github.com/maxdeviant/glenvy/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/maxdeviant/glenvy/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/maxdeviant/glenvy/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/maxdeviant/glenvy/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/maxdeviant/glenvy/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/maxdeviant/glenvy/compare/v0.6.1...v1.0.0
[0.6.1]: https://github.com/maxdeviant/glenvy/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/maxdeviant/glenvy/compare/v0.5.1...v0.6.0
[0.5.1]: https://github.com/maxdeviant/glenvy/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/maxdeviant/glenvy/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/maxdeviant/glenvy/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/maxdeviant/glenvy/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/maxdeviant/glenvy/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/maxdeviant/glenvy/compare/c28c7de...v0.1.0
