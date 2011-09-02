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
    ObjectSpace.each_object(Module) do |o|
      modules << o if should_extract_from?(o)
    end
    modules << Kernel
    modules
  end

  def self.should_extract_from?(o)
    return false if (o < Base || o == Base || o.is_a?(Base))
    return o.is_a?(Module) && o != Kernel
  end

  def self.method_missing name, *args, &block
    name_string = name.to_s

    all_modules.each do |mod|
      if mod.respond_to?(name)
        return mod.send name, *args, &block
      elsif mod.instance_methods.include?(name_string)
        return call_instance_method(mod, name, args, block)
      end
    end
    super
  end

  def self.call_instance_method(mod, name, args, block)
    if mod.is_a? Class
      klass = Class.new(mod)
    else
      klass = Class.new { include mod }
    end
    return klass.new.send name, *args, &block
  end

  def method_missing *args, &block
    self.class.method_missing *args, &block
  end

  def self.methods
    giant_method_list_including_object(self)
  end

  def methods
    self.class.giant_method_list_including_object(self)
  end

  # INHERIT ALL THE METHODS!
  def self.giant_method_list_including_object(object)
    methods = []
    all_modules.each_with_index do |m, i|
      # Don't recurse into other Base objects' "methods" method
      if m.is_a?(Base) || m < Base || m == Base
        []
      else
        methods += m.methods
      end
    end
    methods.uniq
  end
end

