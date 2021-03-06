# Changelog

## [Unreleased](https://github.com/yykamei/rails_band/tree/HEAD)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.7.0...HEAD)

**Implemented enhancements:**

- Support process\_middleware.action\_dispatch [\#98](https://github.com/yykamei/rails_band/pull/98) ([yykamei](https://github.com/yykamei))

## [v0.7.0](https://github.com/yykamei/rails_band/tree/v0.7.0) (2022-05-31)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.6.1...v0.7.0)

**Breaking changes:**

- Remove `#children` fron `BaseEvent` [\#90](https://github.com/yykamei/rails_band/pull/90) ([yykamei](https://github.com/yykamei))

**Implemented enhancements:**

- Support render\_layout.action\_view [\#96](https://github.com/yykamei/rails_band/pull/96) ([yykamei](https://github.com/yykamei))
- Add \#abort in ActiveJob instrumentations [\#94](https://github.com/yykamei/rails_band/pull/94) ([yykamei](https://github.com/yykamei))
- Support deprecation.rails [\#89](https://github.com/yykamei/rails_band/pull/89) ([yykamei](https://github.com/yykamei))

## [v0.6.1](https://github.com/yykamei/rails_band/tree/v0.6.1) (2022-04-01)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.6.0...v0.6.1)

**Fixed bugs:**

- Fix Railtie to set consumers without \#swap [\#87](https://github.com/yykamei/rails_band/pull/87) ([yykamei](https://github.com/yykamei))

## [v0.6.0](https://github.com/yykamei/rails_band/tree/v0.6.0) (2022-03-04)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.5.0...v0.6.0)

**Implemented enhancements:**

- Support transform.active\_storage [\#83](https://github.com/yykamei/rails_band/pull/83) ([yykamei](https://github.com/yykamei))
- Support analyze.active\_storage [\#81](https://github.com/yykamei/rails_band/pull/81) ([yykamei](https://github.com/yykamei))
- Support service\_update\_metadata.active\_storage [\#76](https://github.com/yykamei/rails_band/pull/76) ([yykamei](https://github.com/yykamei))
- Support service\_url.active\_storage [\#74](https://github.com/yykamei/rails_band/pull/74) ([yykamei](https://github.com/yykamei))
- Support service\_exist.active\_storage [\#72](https://github.com/yykamei/rails_band/pull/72) ([yykamei](https://github.com/yykamei))
- Support service\_delete\_prefixed.active\_storage [\#70](https://github.com/yykamei/rails_band/pull/70) ([yykamei](https://github.com/yykamei))
- Support service\_delete.active\_storage [\#67](https://github.com/yykamei/rails_band/pull/67) ([yykamei](https://github.com/yykamei))
- Support service\_download.active\_storage [\#65](https://github.com/yykamei/rails_band/pull/65) ([yykamei](https://github.com/yykamei))
- Support service\_download\_chunk.active\_storage [\#63](https://github.com/yykamei/rails_band/pull/63) ([yykamei](https://github.com/yykamei))
- Support service\_streaming\_download.active\_storage [\#61](https://github.com/yykamei/rails_band/pull/61) ([yykamei](https://github.com/yykamei))
- Support service\_upload.active\_storage [\#59](https://github.com/yykamei/rails_band/pull/59) ([yykamei](https://github.com/yykamei))

**Merged pull requests:**

- Support preview.active\_storage [\#78](https://github.com/yykamei/rails_band/pull/78) ([yykamei](https://github.com/yykamei))
- Support Ruby 3.1 [\#57](https://github.com/yykamei/rails_band/pull/57) ([yykamei](https://github.com/yykamei))

## [v0.5.0](https://github.com/yykamei/rails_band/tree/v0.5.0) (2021-12-25)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.4.0...v0.5.0)

**Implemented enhancements:**

- Support broadcast.action\_cable [\#54](https://github.com/yykamei/rails_band/pull/54) ([yykamei](https://github.com/yykamei))
- Support transmit\_subscription\_rejection.action\_cable [\#52](https://github.com/yykamei/rails_band/pull/52) ([yykamei](https://github.com/yykamei))
- Support transmit\_subscription\_confirmation.action\_cable [\#50](https://github.com/yykamei/rails_band/pull/50) ([yykamei](https://github.com/yykamei))
- Support transmit.action\_cable [\#43](https://github.com/yykamei/rails_band/pull/43) ([yykamei](https://github.com/yykamei))
- Support perform\_action.action\_cable [\#40](https://github.com/yykamei/rails_band/pull/40) ([yykamei](https://github.com/yykamei))

**Fixed bugs:**

- CI with edge Rails fails [\#45](https://github.com/yykamei/rails_band/issues/45)

**Merged pull requests:**

- Support Rails 7 ???? [\#48](https://github.com/yykamei/rails_band/pull/48) ([yykamei](https://github.com/yykamei))
- Avoid using :require to reserve @logging\_context [\#46](https://github.com/yykamei/rails_band/pull/46) ([yykamei](https://github.com/yykamei))

## [v0.4.0](https://github.com/yykamei/rails_band/tree/v0.4.0) (2021-11-19)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.3.0...v0.4.0)

**Implemented enhancements:**

- Support discard.active\_job [\#38](https://github.com/yykamei/rails_band/pull/38) ([yykamei](https://github.com/yykamei))
- Support retry\_stopped.active\_job [\#36](https://github.com/yykamei/rails_band/pull/36) ([yykamei](https://github.com/yykamei))
- Suppoer perform.active\_job [\#34](https://github.com/yykamei/rails_band/pull/34) ([yykamei](https://github.com/yykamei))
- Support perform\_start.active\_job [\#32](https://github.com/yykamei/rails_band/pull/32) ([yykamei](https://github.com/yykamei))
- Support enqueue\_retry.active\_job [\#30](https://github.com/yykamei/rails_band/pull/30) ([yykamei](https://github.com/yykamei))
- Support enqueue.active\_job [\#28](https://github.com/yykamei/rails_band/pull/28) ([yykamei](https://github.com/yykamei))
- Support enqueue\_at.active\_job [\#26](https://github.com/yykamei/rails_band/pull/26) ([yykamei](https://github.com/yykamei))

## [v0.3.0](https://github.com/yykamei/rails_band/tree/v0.3.0) (2021-11-08)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.2.0...v0.3.0)

**Implemented enhancements:**

- Support cache\_delete\_multi.active\_support [\#24](https://github.com/yykamei/rails_band/pull/24) ([yykamei](https://github.com/yykamei))
- Support cache\_write\_multi.active\_support [\#22](https://github.com/yykamei/rails_band/pull/22) ([yykamei](https://github.com/yykamei))
- Support cache\_read\_multi.active\_support [\#20](https://github.com/yykamei/rails_band/pull/20) ([yykamei](https://github.com/yykamei))
- Support cache\_exist?.active\_support [\#18](https://github.com/yykamei/rails_band/pull/18) ([yykamei](https://github.com/yykamei))
- Support cache\_delete.active\_support [\#16](https://github.com/yykamei/rails_band/pull/16) ([yykamei](https://github.com/yykamei))
- Support cache\_write.active\_support [\#14](https://github.com/yykamei/rails_band/pull/14) ([yykamei](https://github.com/yykamei))
- Support cache\_fetch\_hit.active\_support [\#12](https://github.com/yykamei/rails_band/pull/12) ([yykamei](https://github.com/yykamei))
- Support cache\_generate.active\_support [\#10](https://github.com/yykamei/rails_band/pull/10) ([yykamei](https://github.com/yykamei))
- Support cache\_read.active\_support [\#8](https://github.com/yykamei/rails_band/pull/8) ([yykamei](https://github.com/yykamei))

## [v0.2.0](https://github.com/yykamei/rails_band/tree/v0.2.0) (2021-11-01)

[Full Changelog](https://github.com/yykamei/rails_band/compare/v0.1.0...v0.2.0)

**Implemented enhancements:**

- Support process.action\_mailer [\#4](https://github.com/yykamei/rails_band/pull/4) ([yykamei](https://github.com/yykamei))
- Support deliver.action\_mailer [\#2](https://github.com/yykamei/rails_band/pull/2) ([yykamei](https://github.com/yykamei))

## [v0.1.0](https://github.com/yykamei/rails_band/tree/v0.1.0) (2021-10-19)

[Full Changelog](https://github.com/yykamei/rails_band/compare/bb7addd0e9a1f460a08eed62655fe5977be85f54...v0.1.0)

**Merged pull requests:**

- Add ci.yml to run tests [\#1](https://github.com/yykamei/rails_band/pull/1) ([yykamei](https://github.com/yykamei))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
