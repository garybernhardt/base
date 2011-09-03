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
    call_method(self, name, args, block)
  end

  def method_missing name, *args, &block
    self.class.call_method(self, name, args, block)
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
    #   2.1. So we need to call method_missing.
    #     2.1.1. We can't just super it because we're not in method_missing.
    #       2.1.1.1. We're not in method_missing because there are two of them
    #                (self and instance) that need to share this code.
    #       2.1.1.2. We need to call the method that would be called if we said
    #                "super" in the object's method_missing.
    #         2.1.1.2.1. Which is its class's superclass's method_missing method
    #                    object.
    Object.instance_method(:method_missing).bind(object).call(name, *args, &block)
  end

  def self.call_instance_method(mod, name, args, block)
    if mod.is_a? Class
      klass = Class.new(mod)
    else
      klass = Class.new { include mod }
    end
    return klass.new.send name, *args, &block
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
    all_modules.each_with_index do |m, i|
      # Don't recurse into other Base objects' "methods" method
      next if m.is_a?(Base) || m < Base || m == Base
      methods += m.methods + m.instance_methods
    end
    methods
  end
end

