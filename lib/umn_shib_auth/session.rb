module UmnShibAuth
  class Session
    attr_reader :eppn, :internet_id, :institution_tld
    def initialize(*args)
      options = args.extract_options!
      options.symbolize_keys!
      if options[:eppn].blank?
        raise "Yo, we only know how to function with :eppn specified"
      else
        @eppn = options[:eppn]
      end
      @internet_id, @institution_tld = @eppn.split('@')
    end
  end
end
