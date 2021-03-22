require 'thor'

module RubyAudit
  class CLI < ::Thor
    default_task :check
    map '--version' => :version

    desc 'check', 'Checks Ruby and RubyGems for insecure versions'
    method_option :ignore, type: :array, aliases: '-i'
    method_option :no_update, type: :boolean, aliases: '-n'
    method_option :verbose, type: :boolean, aliases: '-v'
    def check
      update unless options[:no_update]

      check_for_stale_database

      scanner = Scanner.new
      vulnerable = false

      scanner.scan(ignore: options[:ignore]) do |result|
        vulnerable = true
        print_advisory result.gem, result.advisory
      end

      if vulnerable
        say 'Vulnerabilities found!', :red
        exit 1
      else
        say 'No vulnerabilities found', :green
      end
    end

    # Copied from bundler-audit master. Not present in 0.4.0.
    desc 'update', 'Updates the ruby-advisory-db'
    def update
      say 'Updating ruby-advisory-db ...'

      case Database.update!
      when true
        say 'Updated ruby-advisory-db', :green
      when false
        say 'Failed updating ruby-advisory-db!', :red
        exit 1
      when nil
        say 'Skipping update', :yellow
      end

      puts "ruby-advisory-db: #{Database.new.size} advisories"
    end

    desc 'version', 'Prints the ruby-audit version'
    def version
      database = Database.new
      puts "#{File.basename($PROGRAM_NAME)} #{VERSION} "\
           "(advisories: #{database.size})"
    end

    private

    def say(message = '', color = nil)
      color = nil unless $stdout.tty?
      super(message.to_s, color)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def print_advisory(gem, advisory)
      say 'Name: ', :red
      say gem.name

      say 'Version: ', :red
      say gem.version

      say 'Advisory: ', :red

      if advisory.cve
        say advisory.cve_id
      elsif advisory.osvdb
        say advisory.osvdb_id
      elsif advisory.ghsa
        say advisory.ghsa_id
      end

      say 'Criticality: ', :red
      case advisory.criticality
      when :none     then say 'None'
      when :low      then say 'Low'
      when :medium   then say 'Medium', :yellow
      when :high     then say 'High', %i[red bold]
      when :critical then say 'Critical', %i[red bold]
      else                say 'Unknown'
      end

      say 'URL: ', :red
      say advisory.url

      if options.verbose?
        say 'Description:', :red
        say

        print_wrapped advisory.description, indent: 2
        say
      else

        say 'Title: ', :red
        say advisory.title
      end

      if advisory.patched_versions.empty?
        say 'Solution: ', :red
        say 'remove or disable this gem until a patch is available!', %i[red bold]
      else
        say 'Solution: upgrade to ', :red
        say advisory.patched_versions.join(', ')
      end

      say
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize

    def check_for_stale_database
      database = Database.new
      return unless database.size == 89

      # bundler-audit 0.4.0 comes bundled with an old verison of
      # ruby-advisory-db that has 89 advisories and NO advisories for Ruby
      # or RubyGems. If #size == 89, the database has never been updated.
      say 'The database must be updated before using RubyAudit', :red
      exit 1
    end
  end
end
