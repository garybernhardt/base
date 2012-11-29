require File.expand_path('lib/base')

module NormalModule
  Something = 5

  NONDETERMINISTIC_CONSTANT = 1

  def self.a_class_method; 6; end
  def a_module_method; 7; end

  def nondeterministic_method; "potato"; end
end

class NormalClass
  NONDETERMINISTIC_CONSTANT = 2

  def an_instance_method; 8; end

  def nondeterministic_method; "button"; end
end

class ClassWithTwoConstructorArgs
  NONDETERMINISTIC_CONSTANT = 3

  def initialize(x, y)
  end

  def some_method
    "constructor args worked!"
  end

  def nondeterministic_method; "lamp"; end
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

  it "nondeterministically calls different constants" do
    all_results = [1, 2, 3]
    results = Set.new

    # We'd better eventually hit every different constant, dammit!
    # I don't care if it loops forever.
    while (all_results & results.to_a).size != all_results.size do
      begin
        results << InheritsFromBase::NONDETERMINISTIC_CONSTANT
      rescue
      end
    end
  end

  it "nondeterministically calls different module methods" do
    base = InheritsFromBase.new

    all_results = %w(potato button lamp)
    results = Set.new

    while (all_results & results.to_a).size != all_results.size do
      begin
        results << base.nondeterministic_method
      rescue
      end
    end
  end

end

