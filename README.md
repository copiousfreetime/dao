# dao

## SYNOPSIS

a sa-weet-ass library for structuring rails applications using the 'data
access object' design pattern.  dao consists of two main data access
objects, *api* objects and *conducer* objects.  conducers combine the
presenter pattern with the conductor pattern.


### API

    class Api < Dao::Api
      call('/posts') do
        get do
          data[:posts] = Post.all.map{|post| post.attributes}
        end

        post do
          post = Post.new(params[:post])

          if post.save
            data[:post] = post.attributes
          else
            status 420
          end
        end
      end
    end

### CONDUCER

  * TODO

wikipedia has this to say about dao in general

  >
  > In computer software, a data access object (DAO) is an object that
  > provides an abstract interface to some type of database or other
  > persistence mechanism. By mapping application calls to the persistence
  > layer, DAOs provide some specific data operations without exposing
  > details of the database. This isolation supports the single
  > responsibility principle. It separates what data accesses the
  > application needs, in terms of domain-specific objects and data types
  > (the public interface of the DAO), from how these needs can be satisfied
  > with a specific DBMS, database schema, etc. (the implementation of the
  > DAO).
  >
  -- http://en.wikipedia.org/wiki/Data_access_object

and this to say about the single responsibility principle

  >
  > In object-oriented programming, the single responsibility principle
  > states that every class should have a single responsibility, and that
  > responsibility should be entirely encapsulated by the class. All its
  > services should be narrowly aligned with that responsibility.

  > Responsibility [is defined] as a reason to change, and [single
  > responsibility means] that a class or module should have one, and only
  > one, reason to change. As an example, consider a module that compiles and
  > prints a report. Such a module can be changed for two reasons. First,
  > the content of the report can change. Second, the format of the report
  > can change. These two things change for very different causes; one
  > substantive, and one cosmetic. The single responsibility principle says
  > that these two aspects of the problem are really two separate
  > responsibilities, and should therefore be in separate classes or
  > modules. It would be a bad design to couple two things that change for
  > different reasons at different times.
  >
  -- http://en.wikipedia.org/wiki/Single_responsibility_principle

even though rails is the sweet, its ActiveRecord class violates (or, at
least, encourages a programmer to violate) the single responsibility
principle

this leads to obvious problems

  >
  > Jim Weirich, at the end of his SOLID Ruby Talk at the 2009 Ruby
  > Conference, asks the audience: "ActiveRecord objects implement a domain
  > concept and a persistence concept. Does this violate the SRP (Single
  > Responsibility Principle)?" The audience agrees that it does violate the
  > SRP. Jim asks if this bothers them. Many members of the audience say
  > yes. Why? It makes testing harder. It makes the persistence object a lot
  > heavier.
  >
  -- http://programmers.stackexchange.com/questions/119352/does-the-activerecord-pattern-follow-encourage-the-solid-design-principles#comment293734_119352

and subtle yet sweeping consequences (as described by uncle bob)

  >
  > The problem I have with ActiveRecord is that it creates confusion about
  > ... two very different styles of programming. A database table is a
  > data structure. It has exposed data and no behavior. But an ActiveRecord
  > appears to be an object. It has “hidden” data, and exposed behavior. I
  > put the word “hidden” in quotes because the data is, in fact, not
  > hidden. Almost all ActiveRecord derivatives export the database columns
  > through accessors and mutators. Indeed, the Active Record is meant to be
  > used like a data structure.

  > On the other hand, many people put business rule methods in their
  > ActiveRecord classes; which makes them appear to be objects. This leads
  > to a dilemma. On which side of the line does the Active Record really
  > fall? Is it an object? Or is it a data structure?

  > This dilemma is the basis for the oft-cited impedance mismatch between
  > relational databases and object oriented languages. Tables are data
  > structures, not classes. Objects are encapsulated behavior, not database
  > rows.

  > ...

  > The problem is that Active Records are data structures. Putting business
  > rule methods in them doesn’t turn them into true objects. In the end,
  > the algorithms that employ ActiveRecords are vulnerable to changes in
  > schema, and changes in type. They are not immune to changes in type, the
  > way algorithms that use objects are.

  > ...

  > So applications built around ActiveRecord are applications built around
  > data structures. And applications that are built around data structures
  > are procedural—they are not object oriented. The opportunity we miss
  > when we structure our applications around ActiveRecord is the
  > opportunity to use object oriented design.
  >
  -- https://sites.google.com/site/unclebobconsultingllc/active-record-vs-objects

and a clear solution (again, uncle bob)

  > I am not recommending against the use of ActiveRecord. I think the
  > pattern is very useful. What I am advocating is a separation between the
  > application and ActiveRecord.

  > ActiveRecord belongs in the layer that separates the database from the
  > application. It makes a very convenient halfway-house between the hard
  > data structures of database tables, and the behavior exposing objects in
  > the application.

  > Applications should be designed and structured around objects, not data
  > structures. Those objects should expose business behaviors, and hide any
  > vestige of the database.
  >
  -- https://sites.google.com/site/unclebobconsultingllc/active-record-vs-objects

welcome to the dao


## DESCRIPTION

### API

applications that are written on dao look like this in ruby

      result = api.call('/posts/new', params)

and like this in javascript

      result = api.call('/posts/new', params)

in command-line applications they look like this

      result = api.call('/posts/new', params)

and in tests this syntax is used

      result = api.call('/posts/new', params)

when a developer wants to understand the interface of a dao application she does
this

      vi app/api.rb

when a developer of a dao application wants to play with a dao application
interactively she does

      (rails console)

      > api = Api.new result = api.call('/posts/new', params)

when a remote client wants to understand the api of a dao application she
does

      curl --silent http://dao.app.com/api | less



this kind of brutally consistent interface is made possible by structuring
access to data around the finest data structure of all time - the hash.
in the case of dao the hash is a well structured and slightly clever hash,
but a simple hash interface is the basis of every bit of goodness dao has
to offer.

in dao, application developers do not bring models into controllers and,
especially not into views.  instead, a unified interface to application
logic and data is used everywhere: in tests, in controllers, from the
command-line, and also from javascript.

this seperation of concerns brings with it many, many desirable qualities:

  - total seperation of concerns between the front and back end of a web
    application.  when developers are using dao changes to the data model
    have zero effect on controllers and views.

  - issues related to having models in controllers and views such as
    difficulty reasoning about caching and n+1 queries in views killing
    the db simply disappear.

  - bad programming practices like using quasi-global variables
    (current_user) or decorating models with view specific attributes
    (password_verification) are no longer needed.

  - developers are able to reason over the abilities of an application by
    reading only a few source files.

  - databases can be swapped, mixed, or alternate storage/caching
    mechanisms added at any time without affecting the application's
    controllers or views.

  - transition from form based views to semi-ajax ones to fully-ajax ones
    is direct.

  - forms and interfaces that involve dozens of models are as easy to deal
    with as simple ones.

  - code can be optimized at the interface.

## READING

  * http://blog.plataformatec.com.br/2012/03/barebone-models-to-use-with-actionpack-in-rails-4-0/
  * http://martinfowler.com/eaaCatalog/serviceLayer.html
  * http://blog.firsthand.ca/2011/10/rails-is-not-your-application.html
  * http://best-practice-software-engineering.ifs.tuwien.ac.at/patterns/dao.html
  * http://www.codefutures.com/data-access-object/
  * http://java.sun.com/blueprints/corej2eepatterns/Patterns/DataAccessObject.html
  * http://www.paperplanes.de/2010/5/7/activerecord_callbacks_ruined_my_life.html
  * http://google-styleguide.googlecode.com/svn/trunk/jsoncstyleguide.xml
  * http://pragdave.blogs.pragprog.com/pragdave/2007/03/the_radar_archi.html
  * http://borisstaal.com/post/22586260753/mvc-in-a-browser-vs-reality


## INSTALL

    gem 'dao', :path => File.expand_path('..') ### Gemfile
    rails generate dao api
    vim -o app/api.rb app/controllers/api_controller.rb
    curl --silent http://0.0.0.0:3000/api
    curl --silent http://0.0.0.0:3000/api/ping

## HISTORY

###  4.0.0
  - dao depends has tied itself to rails, for better or worse...
  - drop custom form encoding.  just use a rack-like approach.
  - dao form parameter encoding has changed slightly to 'dao[/api/path][x,y,z]=42'
  - dao form paramters are now preparsed in a before filter
