require "spec_helper"
require "standard"
require "cc/engine/file_list_resolver"

module CC::Engine
  describe FileListResolver do
    include FilesystemHelpers

    before { @code = Dir.mktmpdir }
    let(:builds_config) { ::Standard::BuildsConfig.new.call([]) }

    it "uses default include path" do
      Dir.chdir(@code) do
        create_source_file("a.rb", "def a; true; end")
        create_source_file("not_ruby.txt", "some text")

        resolver = FileListResolver.new(root: @code, engine_config: {}, builds_config: builds_config)
        expect(resolver.expanded_list).to eq [Pathname.new("a.rb").realpath.to_s]
      end
    end

    it "finds ruby scripts without extensions" do
      Dir.chdir(@code) do
        create_source_file("a.rb", "def a; true; end")
        create_source_file("scripts/some_script", "#!/usr/bin/env ruby")
        create_source_file("scripts/some_other_script", "#!/usr/bin/env sh")

        resolver = FileListResolver.new(root: @code, engine_config: {}, builds_config: builds_config)
        expect(resolver.expanded_list).to eq %w[a.rb scripts/some_script].map { |fn| Pathname.new(fn).realpath.to_s }
      end
    end

    it "respects engine config include_paths" do
      Dir.chdir(@code) do
        create_source_file("a.rb", "def a; true; end")
        create_source_file("src/b.rb", "def a; true; end")

        resolver = FileListResolver.new(root: @code, engine_config: {"include_paths" => %w[src/]}, builds_config: builds_config)
        expect(resolver.expanded_list).to eq [Pathname.new("src/b.rb").realpath.to_s]
      end
    end

    it "respects default ignore list" do
      Dir.chdir(@code) do
        create_source_file("vendor/foo/a.rb", "def a; true; end")
        create_source_file("bin/b.rb", "def a; true; end")
        create_source_file("tmp/c.rb", "def a; true; end")
        create_source_file("db/schema.rb", "ActiveRecord::Schema.define(:version => #{Time.current.to_i}) do; end")

        resolver = FileListResolver.new(root: @code, engine_config: {}, builds_config: builds_config)
        expect(resolver.expanded_list).to be_empty
      end
    end

    it "respects ignore list in standard config" do
      Dir.chdir(@code) do
        create_source_file("Gemfile", "source 'https://rubygems.org'")
        create_source_file("src/b.rb", "def a; true; end")
        create_source_file("src/c.rb", "def a; true; end")
        create_source_file(".standard.yml", <<~YAML)
          ignore:
            - src/c.rb
            - Gemfile
        YAML

        resolver = FileListResolver.new(root: @code, engine_config: {}, builds_config: builds_config)
        expect(resolver.expanded_list).to eq [Pathname.new("src/b.rb").realpath.to_s]
      end
    end

    it "handles missing files" do
      Dir.chdir(@code) do
        create_source_file("src/b.rb", "def a; true; end")

        resolver = FileListResolver.new(root: @code, engine_config: {"include_paths" => %w[src/ public/assets]}, builds_config: builds_config)
        expect(resolver.expanded_list).to eq [Pathname.new("src/b.rb").realpath.to_s]
      end
    end
  end
end
