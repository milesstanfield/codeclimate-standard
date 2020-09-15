require "spec_helper"
require "cc/engine/issue"

module CC::Engine
  describe Issue do
    describe "#to_json" do
      let(:offense) do
        location = OpenStruct.new
        location.first_line = 10
        location.last_line = 10
        location.column = 3
        location.last_column = 99

        offense = OpenStruct.new
        offense.cop_name = "Metrics/CyclomaticComplexity"
        offense.message = "Cyclomatic complexity for complex_method is too high [10/5]"
        offense.location = location
        offense
      end

      it "returns a json issue for a Rubocop offense" do
        issue = Issue.new(offense, "app/models/user.rb")
        attributes = JSON.parse(issue.to_json)

        expect(attributes["type"]).to eq("Issue")
        expect(attributes["check_name"]).to eq("Rubocop/Metrics/CyclomaticComplexity")
        expect(attributes["description"]).to eq("Cyclomatic complexity for complex_method is too high [10/5]")
        expect(attributes["categories"]).to eq(["Complexity"])
        expect(attributes["remediation_points"]).to eq(50_000)
        expect(attributes["location"]["path"]).to eq("app/models/user.rb")
        expect(attributes["location"]["positions"]["begin"]["line"]).to eq(10)
        expect(attributes["location"]["positions"]["end"]["line"]).to eq(10)
        expect(attributes["location"]["positions"]["begin"]["column"]).to eq(4)
        expect(attributes["location"]["positions"]["end"]["column"]).to eq(100)
        expect(attributes["content"]["body"].squish).to include(
          "This cop checks that the cyclomatic complexity of methods is not higher than the configured maximum."
        )
      end

      it "sets a fingerprint for method/class offenses" do
        offense.cop_name = "Metrics/AbcSize"
        issue = Issue.new(offense, "app/models/user.rb")
        attributes = JSON.parse(issue.to_json)

        expect(attributes).to have_key("fingerprint")
      end

      it "does not set a fingerprint for other offenses" do
        offense.cop_name = "Style/AlignParameters"
        issue = Issue.new(offense, "app/models/user.rb")
        attributes = JSON.parse(issue.to_json)

        expect(attributes).not_to have_key("fingerprint")
      end
    end

    describe "#remediation points" do
      it "returns the default remediation points" do
        offense = OpenStruct.new
        offense.cop_name = "Some/UnconfiguredCop"
        issue = Issue.new(offense, "/code/file.rb")

        expect(issue.remediation_points).to eq(Issue::DEFAULT_REMEDIATION_POINTS)
      end
    end
  end
end
