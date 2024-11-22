require "spec_helper"

module CC::Engine
  describe "Rubocop config patch" do
    it "prevents config from raising on obsolete cops" do
      config = RuboCop::Config.new(
        {
          "Style/TrailingComma" => {
            "Enabled" => true
          }
        },
        ".rubocop.yml"
      )

      expect { # Suppress output
        expect { config.validate }.to_not raise_error
      }.to output(//).to_stderr
    end

    it "warns about obsolete cops" do
      config = RuboCop::Config.new(
        {
          "Style/TrailingComma" => {
            "Enabled" => true
          }
        },
        ".rubocop.yml"
      )

      expect { config.validate }.to output(<<~TXT).to_stderr
        The `Style/TrailingComma` cop has been removed. Please use `Style/TrailingCommaInArguments`, `Style/TrailingCommaInArrayLiteral` and/or `Style/TrailingCommaInHashLiteral` instead.
        (obsolete configuration found in .rubocop.yml, please update it)
        unrecognized cop or department Style/TrailingComma found in .rubocop.yml
        Did you mean `Style/TrailingCommaInArguments`?
      TXT
    end
  end
end
