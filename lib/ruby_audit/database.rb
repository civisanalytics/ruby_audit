require 'bundler/audit/database'

module RubyAudit
  class Database < Bundler::Audit::Database
    def advisories_for(name, type)
      return enum_for(__method__, name, type) unless block_given?

      each_advisory_path_for(name, type) do |path|
        yield Bundler::Audit::Advisory.load(path)
      end
    end

    def check_ruby(ruby, &)
      check(ruby, 'rubies', &)
    end

    def check_rubygems(rubygems, &)
      check(rubygems, 'gems', &)
    end

    def check(object, type = 'gems')
      return enum_for(__method__, object, type) unless block_given?

      advisories_for(object.name, type) do |advisory|
        yield advisory if advisory.vulnerable?(object.version)
      end
    end

    protected

    def each_advisory_path(&)
      Dir.glob(File.join(@path, '{gems,rubies}', '*', '*.yml'), &)
    end

    def each_advisory_path_for(name, type = 'gems', &)
      Dir.glob(File.join(@path, type, name, '*.yml'), &)
    end
  end
end
