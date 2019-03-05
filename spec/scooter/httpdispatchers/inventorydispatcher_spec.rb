require 'spec_helper'

describe Scooter::HttpDispatchers::InventoryDispatcher do

  let(:inventory_api) { Scooter::HttpDispatchers::InventoryDispatcher.new(host) }
  let(:logger) { double('logger')}
  unixhost = { roles:     ['test_role'],
                   'platform' => 'debian-7-x86_64' }
  let(:host) { Beaker::Host.create('test.com', unixhost, {:logger => logger}) }

  subject { inventory_api }

  before do
    expect(OpenSSL::PKey).to receive(:read).and_return('Pkey')
    expect(OpenSSL::X509::Certificate).to receive(:new).and_return('client_cert')
    allow_any_instance_of(Scooter::HttpDispatchers::InventoryDispatcher).to receive(:get_host_cert) {'host cert'}
    allow_any_instance_of(Scooter::HttpDispatchers::InventoryDispatcher).to receive(:get_host_private_key) {'key file'}
    allow_any_instance_of(Scooter::HttpDispatchers::InventoryDispatcher).to receive(:get_host_cacert) {'cert file'}
    expect(subject).to be_kind_of(Scooter::HttpDispatchers::InventoryDispatcher)
    allow_any_instance_of(Beaker::Http::FaradayBeakerLogger).to receive(:debug) {true}
    allow_any_instance_of(Beaker::Http::FaradayBeakerLogger).to receive(:info) {true}
  end

  it 'should make requests on the correct port' do
    expect(inventory_api.connection.url_prefix.port).to be(8143)
  end

  it 'should use the correct path prefix' do
    expect(inventory_api.connection.url_prefix.path).to eq('/inventory')
  end
  
  describe '.create_connection' do
    let(:connection) {{
        'type' => 'cisco_nexus',
        'certname' => 'happy.device',
        'parameters' => {'one' => 2},
        'sensitive_parameters' => {'three' => 4}
      }}
  
    it { is_expected.not_to respond_to(:create_connection).with(0).arguments }
    it { is_expected.to respond_to(:create_connection).with(1).arguments }
    it { is_expected.not_to respond_to(:create_connection).with(2).arguments }
    
    it 'should take a single connection object' do
      expect(inventory_api.connection).to receive(:post).with("v1/command/create-connection")
      expect{ inventory_api.create_connection(connection) }.not_to raise_error
    end
  end
  
  describe '.list_connections' do
    it {is_expected.to respond_to(:list_connections).with(0).arguments }
    it {is_expected.to respond_to(:list_connections).with(1).arguments }
    it {is_expected.to respond_to(:list_connections).with(2).arguments }
    it {is_expected.not_to respond_to(:list_connections).with(3).arguments }
  end
end