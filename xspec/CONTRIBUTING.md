# Contributing to XSpec

:+1::tada: Thanks for taking the time to contribute! :tada::+1:

## How to contribute

- [Report an issue](https://github.com/xspec/xspec/issues/new): whether you find a bug in XSpec or have a feature request, raise an issue to let us know. Please submit code examples to reproduce a bug and read the [wiki](https://github.com/xspec/xspec/wiki) to check how XSpec is supposed to work.
- [Raise a pull request](https://github.com/xspec/xspec/pulls): all code changes in XSpec are initiated via pull requests towards the `master` branch and are usually reviewed by a maintainer or another contributor before merging. Your pull request will be automatically scanned by our CI systems so you may want to [run the test suite locally](https://github.com/xspec/xspec/wiki/How-to-Run-the-Test-Suite-Locally) to avoid surprises. If possible, add a test when submitting a bug fix or a new feature and consider writing some documentation in the pull request which could be later added to the wiki. Before implementing a large feature or fix, consider discussing it first with the maintainers via an issue, this usually speeds up the review process and avoids disappointment.
- [Improve the documentation](https://github.com/xspec/xspec/wiki): if you notice a gap in the documentation on the [wiki](https://github.com/xspec/xspec/wiki), raise an issue or discuss it within an existing issue or pull request. Changes in the wiki can only be made by maintainers and contributors with write permissions.

All contributions are submitted under the [MIT License](https://github.com/xspec/xspec/blob/master/LICENSE).

## Code Conventions

### Filename extensions

| Extension | Type                  |
| --------- | --------------------- |
| `xq`      | XQuery main module    |
| `xqm`     | XQuery library module |
| `xsl`     | XSLT stylesheet       |

### Pull request titles

We use GitHub Checks to enforce conventions in pull request titles and we follow the Angular Coding Conventions:

`<type>(<scope>): <subject>`

If you raise a pull request without using this format in its title, the automatic checks in the pull request will report an error.

This convention is enforced only in the pull request title. Each commit message in the pull request is not required to follow the convention, although you're still encouraged to apply the same convention to each commit message.

#### Type

These are the valid prefixes for type (see also [the Angular documentation](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#type)):

| Type       | Description                                         |
| ---------- | --------------------------------------------------- |
| `build`    | Build and release changes                           |
| `ci`       | CI configuration (GitHub Actions, Checks, etc.)     |
| `docs`     | Documentation                                       |
| `feat`     | New feature or enhancement                          |
| `fix`      | Bug fix                                             |
| `perf`     | Performance improvement                             |
| `refactor` | Refactoring improvement (no new feature or bug fix) |
| `revert`   | Revert a previous commit                            |
| `style`    | Style change (white-space, formatting, etc.)        |
| `test`     | Test                                                |

#### Scope

You are also encouraged to use a scope to highlight which functionality is affected by your change:

| Scope        | Description              |
| ------------ | ------------------------ |
| `xslt`       | XSLT                     |
| `xquery`     | XQuery                   |
| `schematron` | Schematron               |
| `oxygen`     | Oxygen                   |
| `basex`      | BaseX                    |
| `deps`       | Dependencies             |
| `deps-dev`   | Development dependencies |
| `report`     | Test result reports      |
| `xproc`      | XProc                    |
| `schema`     | Schema for .xspec files  |
| `maven`      | Maven                    |
| `cli`        | `bin/xspec.*`            |

Note that type is mandatory and scope is optional and both values should be written in lower case.

#### Example

Here are some examples of valid pull request title with type and scope:

```
feat(xslt): add XSLT code coverage transformation scenario
fix(schematron): remove scenario
fix: invalid col element in result HTML
test(xslt): add test for mode="#all"
ci: run tests with XML Calabash 1.1.30
docs: document code coverage
build: increment pom.xml
```
