# Base

* http://github.com/garybernhardt/base

## DESCRIPTION:

People love Base classes! They have tons of methods waiting to be used. Just check out `ActiveRecord::Base`'s method list:

    >> ActiveRecord::Base.methods.length
    => 572

But why stop there? Why not have even more methods? In fact, let's put *every method* on one Base class!

So I did. It's called Base. Just subclass it and feel free to directly reference any class method, instance method, or constant defined on any module or class in the system. Like this:

    class Cantaloupe < Base
      def embiggen
        encode64(deflate(SEPARATOR))
      end
    end

    >> Cantaloupe.new.embiggen
    => "eJzTBwAAMAAw\n"

See that `embiggen` method calling `encode64` and `deflate` methods? Those come from the `Base64` and `Zlib` modules. And the `SEPARATOR` constant is defined in `File`. Base don't care where it's defined! Base calls what it wants!

By the way, remember those 572 ActiveRecord methods? That's amateur stuff. Check out Base loaded inside a Rails app:

    >> Base.new.methods.count
    => 5794

It's so badass that it takes *five seconds* just to answer that question!

Base is just craaazzy! It's the most fearless class in all of Ruby. Base doesn't afraid of anything!

## LICENSE:

Distributed under the union of the terms specified by all current OSI-approved licenses. In the event of a conflict, a die is to be rolled.

## PRAISE FOR BASE

> @garybernhardt @kantrn ... Can't tell if joke or just Ruby.

\- @[shazow](https://twitter.com/#!/shazow/status/109464406739521536)

> @garybernhardt y u troll soooo good? ;-)

\- @[amerine](https://twitter.com/#!/amerine/status/109453913572392960)

> @garybernhardt Imagine all the things you could have done doing not that

\- @[mrb_bk](https://twitter.com/#!/mrb_bk/status/109452972966154240)

> @garybernhardt I hate you.

\- @[jmazzi](https://twitter.com/#!/jmazzi/status/109451655040352256)

## SHOULD I USE THIS IN MY SYSTEM?

Yes. I am being completely serious. You should.

Definitely.

