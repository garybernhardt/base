require 'lib/base'

module NormalModule
  Something = 5

  def self.a_class_method; 6; end
end

class InheritsFromBase < Base
end

describe Base do
  it "should have other modules' constants" do
    InheritsFromBase::Something.should == NormalModule::Something
  end

  it "still throws NameError if the constant doesn't exist" do
    expect do
      InheritsFromBase::SomethingElse
    end.to raise_error NameError
  end

  it "should have other modules' class methods" do
    InheritsFromBase.a_class_method.should == 6
  end

  it "still throws NoMethodError if the method doesn't exist" do
    expect do
      InheritsFromBase.not_a_method
    end.to raise_error NoMethodError
  end

  it "should have other modules' methods as instance methods" do
    InheritsFromBase.new.a_class_method.should == 6
  end

  it "includes methods from the standard library" do
    InheritsFromBase.inflate(InheritsFromBase.deflate("x")).should == "x"
  end

  it "checks Kernel last" do
    InheritsFromBase.all_modules.last.should == Kernel
  end
end

