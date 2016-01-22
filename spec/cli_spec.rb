require 'spec_helper'

describe RubyAudit::CLI do
  context 'when the database has never been updated' do
    before(:each) do
      allow_any_instance_of(RubyAudit::Database)
        .to receive(:size).and_return(89)
    end

    it 'prints a failure message and exit' do
      subject.options = { no_update: true }
      expect do
        expect { subject.check }.to raise_error(SystemExit)
      end.to output(/The database must be updated before using RubyAudit/)
        .to_stdout
    end
  end

  context 'when the database is stale' do
    before(:each) do
      allow_any_instance_of(RubyAudit::Database)
        .to receive(:stale).and_return(true)
      allow_any_instance_of(RubyAudit::Scanner)
        .to receive(:scan).and_return([])
    end

    it 'prints a warning message' do
      subject.options = { no_update: true }
      expect { subject.check }
        .to output(/The database has not been updated in over 7 days/).to_stdout
    end
  end
end
