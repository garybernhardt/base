class Base
  VERSION = "0.0.1"

  def self.const_missing name
    all_modules.each do |mod|
      return mod.const_get(name) if mod.const_defined?(name)
    end
    super
  end

  def self.all_modules
    modules = ObjectSpace.each_object(Module).select do |mod|
      should_extract_from?(mod)
    end
    modules << Kernel
    modules
  end

  def self.should_extract_from?(mod)
    return false if (mod < Base || mod == Base || mod.is_a?(Base))
    return mod.is_a?(Module) && mod != Kernel
  end

  def self.method_missing name, *args, &block
    call_method(self, name, args, block) { super }
  end

  def method_missing name, *args, &block
    self.class.call_method(self, name, args, block) { super }
  end

  def self.call_method(object, name, args, block)
    name_string = name.to_s

    all_modules.each do |mod|
      if mod.respond_to?(name)
        return mod.send name, *args, &block
      elsif mod.instance_methods.include?(name_string)
        return call_instance_method(mod, name, args, block)
      end
    end

    # 1. The world is all that is the case.
    # 2. We failed to find a method to call.
    #   2.1. call "super" in the context of the method_missing caller
    yield
  end

  def self.call_instance_method(mod, name, args, block)
    if mod.is_a? Class
      klass = Class.new(mod)
    else
      klass = Class.new { include mod }
    end

    object = self.instantiate_regardless_of_argument_count(klass)
    return object.send name, *args, &block
  end

  def self.instantiate_regardless_of_argument_count(klass)
    (0..100).each do |arg_count|
      begin
        return klass.new(*[nil] * arg_count)
      rescue ArgumentError
      end
    end
  end

  def self.methods
    (giant_method_list_including_object(self) + super).uniq
  end

  def methods
    (self.class.giant_method_list_including_object(self) + super).uniq
  end

  # INHERIT ALL THE METHODS!
  def self.giant_method_list_including_object(object)
    methods = []
    all_modules.each do |mod|
      # Don't recurse into other Base objects' "methods" method
      next if mod.is_a?(Base) || mod < Base || mod == Base
      methods.concat(mod.methods).concat(mod.instance_methods)
    end
    methods
  end
end

