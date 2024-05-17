require 'spec_helper'

describe RubyAudit::Database do
  describe '#check_rubygems' do
    let(:rubygems) { RubyAudit::Scanner::Version.new('rubygems-update', '2.4.5') }

    context 'when given a block' do
      it 'should yield every advisory affecting the rubygems version' do
        advisories = []

        subject.check_rubygems(rubygems) do |advisory|
          advisories << advisory
        end

        expect(advisories).not_to be_empty
        expect(advisories.all? do |advisory|
                 advisory.is_a?(Bundler::Audit::Advisory)
               end).to be_truthy
        expect(advisories.map(&:id)).to include('CVE-2015-3900')
        expect(advisories.map(&:path).reject { |p| p =~ /rubygems-update/ })
          .to be_empty
      end
    end

    context 'when given no block' do
      it 'should return an Enumerator' do
        expect(subject.check_rubygems(rubygems)).to be_kind_of(Enumerable)
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
        expect(advisories.map(&:id)).to include('CVE-2015-1855')
        expect(advisories.map(&:path).reject { |p| p =~ /rubies/ }).to be_empty
      end
    end

    context 'when given no block' do
      it 'should return an Enumerator' do
        expect(subject.check_ruby(ruby)).to be_kind_of(Enumerable)
      end
    end
  end
end
