class Base
  def initialize *args, &block
    super *args, &block
  end

  def self.const_missing name
    name = name.to_s
    all_modules.each do |mod|
      mod.constants.each do |constant|
        return mod.const_get(constant) if constant == name
      end
    end
    super
  end

  def self.all_modules
    modules = []
    ObjectSpace.each_object do |o|
      modules << o if o.is_a? Module
    end
    modules
  end

  def self.method_missing name, *args, &block
    all_modules.each do |mod|
      if mod.respond_to? name
        return mod.send name, *args, &block
      end
    end
    super
  end

  def method_missing *args, &block
    self.class.method_missing *args, &block
  end
end

