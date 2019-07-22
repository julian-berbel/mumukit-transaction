RSpec.describe Rack::RequestTracker do
  before { subject.request_id = 'some id' }
  before { subject.request_uid = 'some uid' }
  before { subject.forwarded_for = 'some ip' }

  after { RequestStore.clear! }

  it 'has a version number' do
    expect(subject::VERSION).not_to be nil
  end

  it 'has log tags' do
    expect(subject::LOG_TAGS).to eq %i(request_id forwarded_for request_uid)
  end

  it 'can set each log tag separately' do
    subject.request_id = '12345'

    expect(subject.request_id).to eq '12345'
  end

  describe '.compute_tags' do
    context 'when tags are all set' do
      it { expect(subject.compute_tags).to eq 'some id, some ip, some uid' }
    end

    context 'when some tag is not set' do
      before { subject.request_uid = nil }

      it { expect(subject.compute_tags).to eq 'some id, some ip' }
    end
  end

  describe '.transaction_headers' do
    context 'when tags are all set' do
      it { expect(subject.transaction_headers).to eq 'X-REQUEST-ID' => 'some id',
                                                                  'X-REQUEST-UID' => 'some uid',
                                                                  'X-FORWARDED-FOR' => 'some ip' }
    end

    context 'when some tag is not set' do
      before { subject.request_uid = nil }

      it { expect(subject.transaction_headers).to eq 'X-REQUEST-ID' => 'some id',
                                                                  'X-FORWARDED-FOR' => 'some ip' }
    end
  end

  describe '.with_transaction_headers' do
    before { allow(subject).to receive(:safe_domains).and_return ['my-site.com'] }

    context 'when domain is safe' do
      it { expect(subject.with_transaction_headers url: 'http://my-site.com/somewhere').to eq url: 'http://my-site.com/somewhere',
                                                                                                           headers: {
                                                                                                             'X-REQUEST-ID' => 'some id',
                                                                                                             'X-REQUEST-UID' => 'some uid',
                                                                                                             'X-FORWARDED-FOR' => 'some ip'
                                                                                                           } }
    end

    context 'when domain is unsafe' do
      it { expect(subject.with_transaction_headers url: 'http://my-other-site.com/somewhere').to eq url: 'http://my-other-site.com/somewhere' }
    end
  end
end
