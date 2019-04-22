RSpec.describe Settei do
  it 'has a version number' do
    expect(Settei::VERSION).not_to be nil
  end

  context 'setteings' do
    let(:hash) { { foo: true, bar: 'no', baz: 'shh' } }
    let(:klass) { Class.new.tap { |c| c.include(Settei.setup(hash)) } }
    let(:config) { klass.config }

    it 'has config accessors' do
      expect(klass).to respond_to(:config)
    end

    it 'has public methods' do
      expect(config).to respond_to(:foo)
      expect(config).to respond_to(:bar)
      expect(config).to respond_to(:baz)
    end

    it 'has variants for bools' do
      expect(config).to respond_to(:foo?)
    end

    it 'has defaults' do
      expect(config.foo).to eq(true)
      expect(config.bar).to eq('no')
      expect(config.baz).to eq('shh')
    end

    it 'can take a block' do
      klass.config do |c|
        expect(c.foo).to eq(true)
      end
    end

    it 'remembers values' do
      config.foo = false
      expect(config.foo).not_to be(true)

      config.foo = true
      expect(config.foo).to be(true)
    end

    it 'has working setters' do
      config.bar = 'yes'
      config.foo = false
      expect(config.bar).to eq('yes')
      expect(config.foo).to eq(false)
    end

    it 'checks type' do
      expect{ config.bar = true }.to raise_exception(TypeError)
      expect{ config.foo = 'no' }.to raise_exception(TypeError)
    end
  end
end
