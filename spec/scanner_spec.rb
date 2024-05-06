require 'spec_helper'

describe RubyAudit::Scanner do
  let(:scanner) { described_class.new }

  subject { scanner.scan.to_a }

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
      expect(subject.map { |r| r.advisory.id }).to include('CVE-2015-1855')
    end

    it 'respects patch level' do
      stub_const('RUBY_VERSION', '1.9.3')
      stub_const('RUBY_PATCHLEVEL', 392)
      expect(subject.map { |r| r.advisory.id }).to include('CVE-2014-8080')
    end

    it 'handles preview versions' do
      stub_const('RUBY_VERSION', '2.1.0')
      stub_const('RUBY_PATCHLEVEL', -1)
      allow_any_instance_of(RubyAudit::Scanner)
        .to receive(:ruby_version).and_return('2.1.0.dev')
      expect(subject.map { |r| r.advisory.id }).to include('CVE-2013-4164')
    end

    context 'when the :ignore option is given' do
      subject { scanner.scan(ignore: ['CVE-2015-1855']) }

      it 'should ignore the specified advisories' do
        expect(subject.map { |r| r.advisory.id }).not_to include('CVE-2015-1855')
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
