module RubyAudit
  class Scanner < Bundler::Audit::Scanner
    class Version
      def initialize(name, version)
        @name = name
        @version = Gem::Version.new(version)
      end

      attr_reader :name, :version
    end

    def initialize
      @database = Database.new
    end

    def scan(options = {}, &block)
      return enum_for(__method__, options) unless block

      scan_ruby(options, &block)
      scan_rubygems(options, &block)

      self
    end

    def scan_ruby(options = {}, &block)
      version = if RUBY_PATCHLEVEL < 0
                  ruby_version
                else
                  "#{RUBY_VERSION}.#{RUBY_PATCHLEVEL}"
                end
      specs = [Version.new(RUBY_ENGINE, version)]
      scan_inner(specs, 'ruby', options, &block)
    end

    def scan_rubygems(options = {}, &block)
      specs = [Version.new('rubygems', rubygems_version)]
      scan_inner(specs, 'library', options, &block)
    end

    private

    def ruby_version
      # .gsub to separate strings (e.g., 2.1.0dev -> 2.1.0.dev,
      # 2.2.0preview1 -> 2.2.0.preview.1).
      RUBY_VERSION.gsub(/(\d)([a-z]+)/, '\1.\2')
                  .gsub(/([a-z]+)(\d)/, '\1.\2')
    end

    def rubygems_version
      Gem::VERSION
    end

    def scan_inner(specs, type, options = {})
      return enum_for(__method__, options) unless block_given?

      ignore = Set[]
      ignore += options[:ignore] if options[:ignore]

      specs.each do |spec|
        @database.send("check_#{type}".to_sym, spec) do |advisory|
          unless ignore.include?(advisory.cve_id) ||
                 ignore.include?(advisory.osvdb_id)
            yield UnpatchedGem.new(spec, advisory)
          end
        end
      end
    end
  end
end
