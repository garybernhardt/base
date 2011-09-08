require File.expand_path('lib/base')

module NormalModule
  Something = 5

  def self.a_class_method; 6; end
  def a_module_method; 7; end
end

class NormalClass
  def an_instance_method; 8; end
end

class ClassWithTwoConstructorArgs
  def initialize(x, y)
  end

  def some_method
    "constructor args worked!"
  end
end

class InheritsFromBase < Base
end

describe Base do
  it "has other modules' constants" do
    InheritsFromBase::Something.should == NormalModule::Something
  end

  it "still throws NameError if the constant doesn't exist" do
    expect do
      InheritsFromBase::SomethingElse
    end.to raise_error NameError
  end

  it "has other modules' class methods" do
    InheritsFromBase.a_class_method.should == 6
  end

  it "has other modules' instance methods" do
    InheritsFromBase.a_module_method.should == 7
  end

  it "has other classes' instance methods" do
    InheritsFromBase.an_instance_method.should == 8
  end

  it "still throws NoMethodError if the method doesn't exist" do
    expect do
      InheritsFromBase.not_a_method
    end.to raise_error NoMethodError
  end

  it "has other modules' methods as instance methods" do
    InheritsFromBase.new.a_class_method.should == 6
  end

  it "includes methods from the standard library" do
    InheritsFromBase.inflate(InheritsFromBase.deflate("x")).should == "x"
  end

  it "checks Kernel last" do
    InheritsFromBase.all_modules.last.should == Kernel
  end

  its "instance NoMethodErrors reference the instance" do
    expect do
      InheritsFromBase.new.not_a_method
    end.to raise_error(NoMethodError, /undefined method `not_a_method' for #<InheritsFromBase/)
  end

  it "lists a lot of class methods" do
    InheritsFromBase.methods.count.should > 1500
  end

  it "lists a lot of instance methods" do
    InheritsFromBase.new.methods.count.should > 1500
  end

  it "doesn't list duplicate methods" do
    methods = InheritsFromBase.methods
    methods.uniq.should == methods
  end

  it "instantiates objects with the correct number of arguments" do
    InheritsFromBase.new.some_method.should == "constructor args worked!"
  end
end

