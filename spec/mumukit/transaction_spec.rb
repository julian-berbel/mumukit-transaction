RSpec.describe Mumukit::Transaction do
  before { Mumukit::Transaction.request_id = 'some id' }
  before { Mumukit::Transaction.request_uid = 'some uid' }
  before { Mumukit::Transaction.forwarded_for = 'some ip' }

  after { RequestStore.clear! }

  it 'has a version number' do
    expect(Mumukit::Transaction::VERSION).not_to be nil
  end

  it 'has log tags' do
    expect(Mumukit::Transaction::LOG_TAGS).to eq %i(request_id forwarded_for request_uid)
  end

  it 'can set each log tag separately' do
    Mumukit::Transaction.request_id = '12345'

    expect(Mumukit::Transaction.request_id).to eq '12345'
  end

  describe '.compute_tags' do
    context 'when tags are all set' do
      it { expect(Mumukit::Transaction.compute_tags).to eq 'some id, some ip, some uid' }
    end

    context 'when some tag is not set' do
      before { Mumukit::Transaction.request_uid = nil }

      it { expect(Mumukit::Transaction.compute_tags).to eq 'some id, some ip' }
    end
  end

  describe '.transaction_headers' do
    context 'when tags are all set' do
      it { expect(Mumukit::Transaction.transaction_headers).to eq 'X-REQUEST-ID' => 'some id',
                                                                  'X-REQUEST-UID' => 'some uid',
                                                                  'X-FORWARDED-FOR' => 'some ip' }
    end

    context 'when some tag is not set' do
      before { Mumukit::Transaction.request_uid = nil }

      it { expect(Mumukit::Transaction.transaction_headers).to eq 'X-REQUEST-ID' => 'some id',
                                                                  'X-FORWARDED-FOR' => 'some ip' }
    end
  end

  describe '.with_transaction_headers' do
    before { allow(Mumukit::Transaction).to receive(:safe_domains).and_return ['my-site.com'] }

    context 'when domain is safe' do
      it { expect(Mumukit::Transaction.with_transaction_headers url: 'http://my-site.com/somewhere').to eq url: 'http://my-site.com/somewhere',
                                                                                                           headers: {
                                                                                                             'X-REQUEST-ID' => 'some id',
                                                                                                             'X-REQUEST-UID' => 'some uid',
                                                                                                             'X-FORWARDED-FOR' => 'some ip'
                                                                                                           } }
    end

    context 'when domain is unsafe' do
      it { expect(Mumukit::Transaction.with_transaction_headers url: 'http://my-other-site.com/somewhere').to eq url: 'http://my-other-site.com/somewhere' }
    end
  end
end
