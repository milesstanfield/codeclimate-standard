require "cc/engine/standard"
require "tmpdir"

module StandardRunner
  def self.included(example_group)
    example_group.include FilesystemHelpers
    example_group.around do |example|
      Dir.mktmpdir do |code|
        @code = code
        example.run
      end
    end
  end

  def includes_check?(output, cop_name)
    issues(output).any? { |i| i["check_name"] =~ /#{cop_name}$/ }
  end

  def issues(output = @engine_output)
    output.split("\0").map { |x| JSON.parse(x) }
  end

  def run_engine(config = nil)
    io = StringIO.new
    standard = CC::Engine::Standard.new(@code, config, io)
    standard.run

    @engine_output = io.string
  end
end
