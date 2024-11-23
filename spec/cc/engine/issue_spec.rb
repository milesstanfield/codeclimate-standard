require "spec_helper"
require "cc/engine/issue"
require "ostruct"

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
        offense.cop_name = "Standard/SemanticBlocks"
        offense.message = "Prefer `{...}` over `do...end` for functional blocks."
        offense.location = location
        offense
      end

      it "returns a json issue for a Rubocop offense" do
        issue = Issue.new(offense, "app/models/user.rb")
        attributes = JSON.parse(issue.to_json)

        expect(attributes["type"]).to eq("Issue")
        expect(attributes["check_name"]).to eq("Rubocop/Standard/SemanticBlocks")
        expect(attributes["description"]).to eq("Prefer `{...}` over `do...end` for functional blocks.")
        expect(attributes["categories"]).to eq(["Style"])
        expect(attributes["remediation_points"]).to eq(50_000)
        expect(attributes["location"]["path"]).to eq("app/models/user.rb")
        expect(attributes["location"]["positions"]["begin"]["line"]).to eq(10)
        expect(attributes["location"]["positions"]["end"]["line"]).to eq(10)
        expect(attributes["location"]["positions"]["begin"]["column"]).to eq(4)
        expect(attributes["location"]["positions"]["end"]["column"]).to eq(100)
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
