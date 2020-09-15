require "standard"
require "fileutils"

namespace :docs do
  desc "Scrapes documentation from the rubocop gem"
  task :scrape do
    MIN_LINES = 3
    COP_FOLDERS = %w[bundler gemspec layout lint metrics migration naming performance rails security style].freeze

    files = []

    # dir = "rubocop-git"
    # `rm -rf #{dir}`
    # `git clone https://github.com/rubocop-hq/rubocop #{dir}`
    # FileUtils.cd(dir) do
    #   `git checkout tags/v#{RuboCop::Version.version}`
    # end
    #
    # files += Dir.glob("./#{dir}/lib/rubocop/cop/{#{COP_FOLDERS.join(",")}}/**.rb")
    # `rm -rf #{dir}`

    dir = "standard-git"
    `rm -rf #{dir}`
    `git clone https://github.com/testdouble/standard #{dir}`
    FileUtils.cd(dir) do
      `git checkout tags/v#{Standard::VERSION.version}`
    end

    files += Dir.glob("./#{dir}/lib/standard/cop/**.rb")
    # `rm -rf #{dir}`

    documentation_files = files.each_with_object({}) { |file, hash|
      content = File.read(file)
      content = content.gsub(/.*\n\s+(?=module RuboCop)/, "")

      class_doc = content.match(/(\s+#.*)+/).to_s
      doc_lines = class_doc.
        gsub(/^\n/, "").
        gsub("@example", "### Example:").
        gsub("@good", "# good").
        gsub("@bad", "# bad").
        split("\n").
        map { |line| line.gsub(/\A\s+#\s?/, "") }.
        map { |line| line.gsub(/\A\s{2}/, " " * 4) }.
        join("\n")
      hash[file] = doc_lines
    }

    documentation_files.each do |file_path, documentation|
      namespace = file_path.split("/").slice(-2, 1).join("/")
      file_name = File.basename(file_path, ".rb")

      folder_path = "./config/contents/#{namespace}"
      write_path = "#{folder_path}/#{file_name}.md"

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
