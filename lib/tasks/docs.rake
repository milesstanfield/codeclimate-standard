require "standard"
require "rubocop"
require "rubocop-performance"
require "tmpdir"
require "fileutils"

namespace :docs do
  BASE_PATH = "./config/contents"

  desc "Scrapes documentation from the rubocop gem"
  task :scrape do
    files = []
    documentation_by_file = {}

    Dir.mktmpdir do |dir|
      FileUtils.cd(dir) do
        files += collect_standard_files
        files += collect_rubocop_files
        files += collect_rubocop_performance_files

        documentation_by_file = extract_documentation(files)
      end
    end

    FileUtils.rm_rf(BASE_PATH)
    write_documentation(documentation_by_file)
  end

  MIN_LINES = 3
  COP_FOLDERS = %w[bundler gemspec layout lint migration naming security style].freeze

  def collect_standard_files
    `git clone https://github.com/testdouble/standard`
    FileUtils.cd("standard") do
      `git checkout tags/v#{Standard::VERSION.version}`
    end
    Dir.glob("./standard/lib/standard/cop/**.rb")
  end

  def collect_rubocop_files
    `git clone https://github.com/rubocop-hq/rubocop`
    FileUtils.cd("rubocop") do
      `git checkout tags/v#{RuboCop::Version.version}`
    end
    Dir.glob("./rubocop/lib/rubocop/cop/{#{COP_FOLDERS.join(",")}}/**.rb")
  end

  def collect_rubocop_performance_files
    `git clone https://github.com/rubocop-hq/rubocop-performance`
    FileUtils.cd("rubocop-performance") do
      `git checkout tags/v#{RuboCop::Performance::Version::STRING}`
    end
    Dir.glob("./rubocop-performance/lib/rubocop/cop/performance/**.rb")
  end

  def extract_documentation(files)
    files.each_with_object({}) { |file, hash|
      content = File.read(file)
      content = content.gsub(/.*\n\s+(?=module RuboCop)/, "")

      class_doc = content.match(/(\s+#.*)+/).to_s
      doc_lines = class_doc
        .gsub(/^\n/, "")
        .gsub("@example", "### Example:")
        .gsub("@good", "# good")
        .gsub("@bad", "# bad")
        .split("\n")
        .map { |line| line.gsub(/\A\s+#\s?/, "") }
        .map { |line| line.gsub(/\A\s{2}/, " " * 4) }
        .join("\n")
      hash[file] = doc_lines
    }
  end

  def write_documentation(documentation_by_file_path)
    documentation_by_file_path.each do |file_path, documentation|
      namespace = file_path.split("/").slice(-2, 1).join("/")
      if file_path.include?("/standard/") && namespace == "cop"
        namespace = "standard"
      end
      file_name = File.basename(file_path, ".rb")

      folder_path = File.join(BASE_PATH, namespace)
      write_path = File.join(folder_path, "#{file_name}.md")

      if documentation.split("\n").count >= MIN_LINES
        puts "Writing documentation to #{write_path}"

        FileUtils.mkdir_p(folder_path)
        File.write(write_path, documentation)
      else
        puts "Documentation for #{file_name} looks poor: deleting it."
        FileUtils.rm(write_path) if File.exist?(write_path)
      end
    end
  end
end
