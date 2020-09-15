require "spec_helper"
require "cc/engine/standard"
require "tmpdir"

module CC::Engine
  describe Standard do
    include StandardRunner

    describe "#run" do
      it "analyzes ruby files using rubocop" do
        create_source_file("foo.rb", <<-RUBY)
          def method
            unused = "x"

            return false
          end
        RUBY

        run_engine

        expect(issues).to include_check "Lint/UselessAssignment"
      end

      it "respects the default .standard.yml file" do
        create_source_file("foo.rb", <<~RUBY)
          def method
            unused = "x" and "y"

            return false
          end
        RUBY

        create_source_file(
          ".standard.yml",
          <<~YAML
            ignore:
              - 'foo.rb':
                - Lint/UselessAssignment
          YAML
        )

        run_engine

        expect(issues).to include_check "Style/AndOr"
        expect(issues).to_not include_check "Lint/UselessAssignment"
      end

      it "reads a file with a #!.*ruby declaration at the top" do
        create_source_file("my_script", <<~RUBY)
          #!/usr/bin/env ruby

          def method
            unused = "x"

            return false
          end
        RUBY

        run_engine

        expect(issues).to include_check "Lint/UselessAssignment"
      end

      it "handles different locations properly" do
        allow_any_instance_of(RuboCop::Cop::Team).to receive_message_chain(:investigate, :offenses).and_return(
          [
            OpenStruct.new(
              location: OpenStruct.new(
                line: 1,
                column: 0,
                source_line: "",
              ),
              cop_name: "fake",
              message: "message"
            )
          ]
        )
        create_source_file("my_script.rb", <<~RUBY)
          #!/usr/bin/env ruby

          def method
            unused = "x"

            return false
          end
        RUBY

        run_engine

        location = {
          "path" => "my_script.rb",
          "positions" => {
            "begin" => { "column" => 1, "line" => 1 },
            "end" => { "column" => 1, "line" => 1 }
          }
        }

        expect(issues.first["location"]).to eq(location)
      end

      it "uses only include_paths when they're passed in via the config hash" do
        okay_contents = <<~RUBY
          #!/usr/bin/env ruby

          puts "Hello world"
        RUBY
        create_source_file("included_root_file.rb", okay_contents)
        create_source_file("subdir/subdir_file.rb", okay_contents)
        create_source_file("ignored_root_file.rb", <<~RUBY)
          def method
            unused = "x" and "y"

            return false
          end
        RUBY
        create_source_file("ignored_subdir/subdir_file.rb", <<~RUBY)
          def method
            unused = "x"

            return false
          end
        RUBY

        run_engine(
          "include_paths" => %w[included_root_file.rb subdir/]
        )

        expect(issues).to_not include_check "Lint/UselessAssignment"
        expect(issues).to_not include_check "Style/AndOr"
      end

      it "ignores non-Ruby files even when passed in as include_paths" do
        create_source_file("config.yml", <<~CONFIG)
          foo:
            bar: "baz"
        CONFIG

        run_engine(
          "include_paths" => %w[config.yml]
        )
        issue = issues.find { |i|
          i["description"] == "unexpected token tCOLON"
        }

        expect(issue).to be nil
      end

      it "includes Ruby files even if they don't end with .rb" do
        create_source_file("Rakefile", <<~RUBY)
          def method
            unused = "x"

            return false
          end
        RUBY

        run_engine("include_paths" => %w[Rakefile])

        expect(issues).to include_check "Lint/UselessAssignment"
      end

      it "skips local disables" do
        create_source_file("test.rb", <<~RUBY)
          def method
            # rubocop:disable Lint/UselessAssignment
            unused = "x"

            return false
          end
        RUBY

        run_engine

        expect(issues).to_not include_check "Lint/UselessAssignment"
      end
    end
  end
end
