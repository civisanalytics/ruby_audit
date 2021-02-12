require 'bundler/audit/database'

module RubyAudit
  class Database < Bundler::Audit::Database
    def advisories_for(name, type)
      return enum_for(__method__, name, type) unless block_given?

      each_advisory_path_for(name, type) do |path|
        yield Bundler::Audit::Advisory.load(path)
      end
    end

    def check_ruby(ruby, &block)
      check(ruby, 'rubies', &block)
    end

    def check_library(library, &block)
      check(library, 'libraries', &block)
    end

    def check(object, type = 'gems')
      return enum_for(__method__, object, type) unless block_given?

      advisories_for(object.name, type) do |advisory|
        yield advisory if advisory.vulnerable?(object.version)
      end
    end

    protected

    def each_advisory_path(&block)
      Dir.glob(File.join(@path, '{gems,libraries,rubies}', '*', '*.yml'),
               &block)
    end

    def each_advisory_path_for(name, type = 'gems', &block)
      Dir.glob(File.join(@path, type, name, '*.yml'), &block)
    end
  end
end
