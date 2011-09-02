# Base

* http://github.com/garybernhardt/base

## DESCRIPTION:

People love Base classes! They have tons of methods waiting to be used. Just check out ActiveRecord::Base's method list:

    >> ActiveRecord::Base.methods.length
    => 530 

But why stop there? Why not have even more methods? In fact, let's put EVERY METHOD on one Base class!

So I did. It's called Base. Just subclass it and feel free to directly reference any class method, instance method, or constant defined on any module or class in the system. Like this:

    class Cantaloupe < Base
      def embiggen
        encode64(deflate(SEPARATOR))
      end
    end

    >> Cantaloupe.new.embiggen
    => "eJzTBwAAMAAw\n" 

See that `embiggen` method calling encode64 and deflate methods? Those come from the `Base64` and `Zlib` modules. And the `SEPARATOR` constant is defined in `File`. Base don't care where it's defined! Base will call it!

By the way, remember those 530 ActiveRecord methods? That's amateur stuff. Check out Base loaded inside a Rails app:

    >> Base.new.methods.count
    => 6947 

It's so badass that it takes FIVE SECONDS just to answer that question!

## SHOULD I USE THIS IN MY SYSTEM?

Yes. I am being completely serious. You should.

Definitely.

