require 'spec_helper'

RSpec.describe ValidateCoordinator do
  subject(:coordinator) do
    described_class.new(card_number: card_number)
  end


  describe '.call' do
    let(:card_number) { '' }

    it 'raise invalid error' do
      expect { coordinator.call }.to raise_error(described_class::InvalidCardNumberError)
    end

    context 'with string card number' do
      let(:card_number) { '123456789012345a' }

      it 'raise invalid error' do
        expect { coordinator.call }.to raise_error(described_class::InvalidCardNumberError)
      end
    end

    context 'with a valid number' do
      let(:card_number) { '1234567890123450' }

      it 'return correct hash' do
        expect(coordinator.call).to match(
          hash_including(
            mii: '1',
            industry: 'Airline cards',
            iin: '123456',
            account_number: '789012345',
            check_number: '0'
          )
        )
      end

      context 'with full number that fails luhn' do
        let(:card_number) { '1234567890123451' }

        it 'raise invalid error' do
          expect { coordinator.call }.to raise_error(described_class::InvalidCardNumberError)
        end
      end
    end
  end
end
