RSpec.describe Settei do
  it 'has a version number' do
    expect(Settei::VERSION).not_to be nil
  end

  context 'setteings' do
    before(:each) do
      @class = newklass(
        pub: {
          foo: true,
          bar: 'no',
        },
        priv: {
          baz: 'shh'
        },
        accessors: %w[config jej],
        prefix: '_'
      )
    end

    it 'has config accessors' do
      expect(@class).to respond_to(:config)
      expect(@class).to respond_to(:jej)
    end

    it 'has public methods' do
      expect(@class).to respond_to(:_foo)
      expect(@class).to respond_to(:_foo=)
      expect(@class).to respond_to(:_bar)
      expect(@class).to respond_to(:_bar=)
    end

    it 'has variants for bools' do
      expect(@class).to respond_to(:_foo?)
      expect(@class).to respond_to(:_dont_foo)
      expect(@class).to respond_to(:_do_foo)
      expect(@class).to respond_to(:_foo!)
    end

    it 'does not have methods for private attrs' do
      expect(@class).not_to respond_to(:_baz)
      expect(@class).not_to respond_to(:_baz=)
    end

    it 'has defaults' do
      expect(@class.config[:foo]).to eq(true)
      expect(@class.config[:bar]).to eq('no')
      expect(@class.config[:baz]).to eq('shh')
    end

    it 'can take a block' do
      @class.config do |c|
        expect(c).to eq(@class)
      end
    end

    it 'remembers values' do
      @class._dont_foo
      expect(@class._foo?).not_to be(true)
    end
  end
end
