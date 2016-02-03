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
end
