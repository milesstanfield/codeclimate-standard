# Code Climate Standard Engine

[![Code Climate](https://codeclimate.com/github/jakeonfire/codeclimate-standard/badges/gpa.svg)](https://codeclimate.com/github/jakeonfire/codeclimate-standard)

`codeclimate-standard` is a Code Climate engine that wraps the [Standard](https://github.com/testdouble/standard) static analysis tool. You can run it on your command line using the Code Climate CLI, or on our hosted analysis platform.

[Standard](https://github.com/testdouble/standard) is an opinionated wrapper around [RuboCop](https://github.com/rubocop-hq/rubocop) with no configuration necessary.

You can find some basic setup instructions and links to the Standard OSS project below.

### Installation

1. If you haven't already, [install the Code Climate CLI](https://github.com/codeclimate/codeclimate).
2. Enable the engine by adding the following under `plugins` in your `.codeclimate.yaml`:
    ```yaml
    plugins:
      standard:
        enabled: true
    ```
3. You're ready to analyze! Browse into your project's folder and run `codeclimate analyze`.

### Need help?

For help with Standard, [check out their documentation](https://github.com/testdouble/standard).

If you're running into a Code Climate issue, first check out [our Standard engine docs][cc-docs-standard] and look over this project's [GitHub Issues](https://github.com/codeclimate/codeclimate-standard/issues), as your question may have already been covered. If not, [go ahead and open a support ticket with us](https://codeclimate.com/help).

[cc-docs-standard]: https://docs.codeclimate.com/docs/standard
