module Dao
  Version = '6.1.0' unless defined?(Version)

  def version
    Dao::Version
  end

  def dependencies
    {
      'rails'             => [ 'rails'             , ' ~> 5.2' ] ,
      'map'               => [ 'map'               , ' ~> 6.0' ] ,
      'fattr'             => [ 'fattr'             , ' ~> 2.2' ] ,
      'coerce'            => [ 'coerce'            , ' ~> 0.0' ] ,
      'tagz'              => [ 'tagz'              , ' ~> 9.9' ] ,
      'multi_json'        => [ 'multi_json'        , ' ~> 1.0' ] ,
      'uuidtools'         => [ 'uuidtools'         , ' ~> 2.1' ] ,
      'wrap'              => [ 'wrap'              , ' ~> 1.5' ] ,
      'rails_current'     => [ 'rails_current'     , ' ~> 2.0' ] ,
    }
  end

  def description
    "presenter, conductor, api, and better form objects for you rails' pleasure"
  end

  def libdir(*args, &block)
    @libdir ||= File.dirname(File.expand_path(__FILE__).sub(/\.rb$/,''))
    args.empty? ? @libdir : File.join(@libdir, *args)
  ensure
    if block
      begin
        $LOAD_PATH.unshift(@libdir)
        block.call()
      ensure
        $LOAD_PATH.shift()
      end
    end
  end

  def load(*libs)
    libs = libs.join(' ').scan(/[^\s+]+/)
    Dao.libdir{ libs.each{|lib| Kernel.load(lib) } }
  end

  extend Dao
end
