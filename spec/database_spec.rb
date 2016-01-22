require 'spec_helper'

describe RubyAudit::Database do
  describe '#check_library' do
    let(:library) { RubyAudit::Scanner::Version.new('rubygems', '2.4.5') }

    context 'when given a block' do
      it 'should yield every advisory affecting the library' do
        advisories = []

        subject.check_library(library) do |advisory|
          advisories << advisory
        end

        expect(advisories).not_to be_empty
        expect(advisories.all? do |advisory|
                 advisory.is_a?(Bundler::Audit::Advisory)
               end).to be_truthy
        expect(advisories.map(&:id)).to include('CVE-2015-3900')
        expect(advisories.map(&:path).reject { |p| p =~ /libraries/ })
          .to be_empty
      end
    end

    context 'when given no block' do
      it 'should return an Enumerator' do
        expect(subject.check_library(library)).to be_kind_of(Enumerable)
      end
    end
  end

  describe '#check_ruby' do
    let(:ruby) { RubyAudit::Scanner::Version.new('ruby', '2.2.1') }

    context 'when given a block' do
      it 'should yield every advisory affecting the Ruby version' do
        advisories = []

        subject.check_ruby(ruby) do |advisory|
          advisories << advisory
        end

        expect(advisories).not_to be_empty
        expect(advisories.all? do |advisory|
                 advisory.is_a?(Bundler::Audit::Advisory)
               end).to be_truthy
        expect(advisories.map(&:id)).to include('OSVDB-120541')
        expect(advisories.map(&:path).reject { |p| p =~ /rubies/ }).to be_empty
      end
    end

    context 'when given no block' do
      it 'should return an Enumerator' do
        expect(subject.check_ruby(ruby)).to be_kind_of(Enumerable)
      end
    end
  end

  describe '#stale' do
    context 'when USER_PATH is missing' do
      before(:each) do
        stub_const('Bundler::Audit::Database::USER_PATH',
                   File.join(File.dirname(__FILE__), '..', 'vendor',
                             'does_not_exist'))
      end

      it { expect(subject.stale).to be true }
    end

    context 'when USER_PATH is not a git repository' do
      before(:each) do
        stub_const('Bundler::Audit::Database::USER_PATH',
                   File.join(File.dirname(__FILE__), '..', 'vendor'))
      end

      it { expect(subject.stale).to be true }
    end

    context 'when USER_PATH is more than 7 days old' do
      before(:each) do
        stub_const('Bundler::Audit::Database::USER_PATH',
                   File.join(File.dirname(__FILE__), '..', 'vendor',
                             'ruby-advisory-db'))
        Timecop.freeze(Time.gm(2016, 1, 30).utc)
      end

      after(:each) do
        Timecop.return
      end

      it { expect(subject.stale).to be true }
    end

    context 'when USER_PATH is less than 7 days old' do
      before(:each) do
        stub_const('Bundler::Audit::Database::USER_PATH',
                   File.join(File.dirname(__FILE__), '..', 'vendor',
                             'ruby-advisory-db'))
        Timecop.freeze(Time.gm(2016, 1, 23).utc)
      end

      after(:each) do
        Timecop.return
      end

      it { expect(subject.stale).to be false }
    end
  end
end
