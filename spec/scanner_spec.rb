require 'spec_helper'

describe RubyAudit::Scanner do
  let(:scanner) { described_class.new }

  subject { scanner.scan.to_a }

  context 'jruby' do
    before(:each) do
      stub_const('RUBY_ENGINE', 'jruby')
      stub_const('JRUBY_VERSION', '1.4.0')
      allow_any_instance_of(RubyAudit::Scanner)
        .to receive(:rubygems_version).and_return('2.4.5')
    end

    it 'handles jruby versions' do
      allow_any_instance_of(RubyAudit::Scanner)
        .to receive(:ruby_version).and_return('1.4.0')
      expect(subject.map { |r| r.advisory.id }).to include('CVE-2010-1330')
    end
  end

  context 'ruby' do
    before(:each) do
      stub_const('RUBY_VERSION', '2.2.1')
      stub_const('RUBY_ENGINE', 'ruby')
      stub_const('RUBY_PATCHLEVEL', 85)
      allow_any_instance_of(RubyAudit::Scanner)
        .to receive(:rubygems_version).and_return('2.4.5')
    end

    context 'when auditing an unpatched Ruby' do
      it 'should match an unpatched Ruby to its advisories' do
        expect(subject.all? do |result|
          result.advisory.vulnerable?(result.gem.version)
        end).to be_truthy
        expect(subject.map { |r| r.advisory.id }).to include('OSVDB-120541')
      end

      it 'respects patch level' do
        stub_const('RUBY_VERSION', '1.9.3')
        stub_const('RUBY_PATCHLEVEL', 392)
        expect(subject.map { |r| r.advisory.id }).to include('OSVDB-113747')
      end

      it 'handles preview versions' do
        stub_const('RUBY_VERSION', '2.1.0')
        stub_const('RUBY_PATCHLEVEL', -1)
        allow_any_instance_of(RubyAudit::Scanner)
          .to receive(:ruby_version).and_return('2.1.0.dev')
        expect(subject.map { |r| r.advisory.id }).to include('OSVDB-100113')
      end

      context 'when the :ignore option is given' do
        subject { scanner.scan(ignore: ['OSVDB-120541']) }

        it 'should ignore the specified advisories' do
          expect(subject.map { |r| r.advisory.id }).not_to include('OSVDB-120541')
        end
      end
    end

    context 'when auditing an unpatched RubyGems' do
      it 'should match an unpatched RubyGems to its advisories' do
        expect(subject.all? do |result|
          result.advisory.vulnerable?(result.gem.version)
        end).to be_truthy
        expect(subject.map { |r| r.advisory.id }).to include('CVE-2015-3900')
      end

      context 'when the :ignore option is given' do
        subject { scanner.scan(ignore: ['CVE-2015-3900']) }

        it 'should ignore the specified advisories' do
          expect(subject.map { |r| r.advisory.id })
            .not_to include('CVE-2015-3900')
        end
      end
    end
  end
end
