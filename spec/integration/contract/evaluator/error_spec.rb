# frozen_string_literal: true

RSpec.describe Dry::Validation::Evaluator, '#error?' do
  let(:contract) do
    Class.new(Dry::Validation::Contract) do
      schema do
        required(:email).filled(:string)
        required(:name).filled(:string)
      end

      rule(:email) do
        key.failure('is not valid') unless value.include?('@')
      end

      rule(:name) do
        key.failure('first introduce a valid email') if error?(:email)
      end
    end
  end

  it 'it checks for errors in given key' do
    expect(contract.new.(email: 'foo', name: 'foo').errors.to_h).to eql({
      email: ['is not valid'],
      name: ['first introduce a valid email']
    })
  end
end
