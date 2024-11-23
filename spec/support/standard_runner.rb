require "cc/engine/standard"
require "tmpdir"

module StandardRunner
  def self.included(example_group)
    example_group.include FilesystemHelpers
    example_group.before do
      allow_any_instance_of(RuboCop::AST::ProcessedSource).to receive(:registry).and_return(registry)
    end
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
    @config = config
    io = StringIO.new
    standard = CC::Engine::Standard.new(@code, @config, io)
    standard.run

    @engine_output = io.string
  end

  def registry
    # https://github.com/rubocop/rubocop/blob/master/lib/rubocop/rspec/cop_helper.rb
    @registry ||= begin
      keys = RuboCop::Config.new(@config || {}, "#{Dir.pwd}/.rubocop.yml").keys
      cops = keys.map { |directive| RuboCop::Cop::Registry.global.find_cops_by_directive(directive) }.flatten
      cops << cop_class if defined?(cop_class) && !cops.include?(cop_class)
      cops.compact!
      RuboCop::Cop::Registry.new(cops)
    end
  end
end
