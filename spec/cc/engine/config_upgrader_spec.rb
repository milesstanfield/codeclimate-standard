# frozen_string_literal: true

require "spec_helper"

module CC::Engine
  describe ConfigUpgrader do
    include StandardRunner

    it "upgrades old configs" do
      create_source_file("test.rb", <<~RUBY)
        # frozen_string_literal: true

        def get_true
          true
        end
      RUBY
      create_source_file(".rubocop.yml", <<~YAML)
        AllCops:
          NewCops: disable
        Style/AccessorMethodName:
          Enabled: false
      YAML

      # No warnings about obsolete cop name
      expect {
        run_engine
      }.to_not output.to_stderr

      # Properly applied config
      expect(issues).to be_empty
    end
  end
end
