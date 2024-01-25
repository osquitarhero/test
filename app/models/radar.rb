class Radar
  
  # available criterias and evaluation priority
  # as filters can be additional to each others
  # process first those that could return multiple results (type and school)
  # FIXME just for development purposes
  AVAILABLE_CRITERIA = %i[ type school latest closest]
  
  def initialize(criteria,editions)
    # parse criteria list
    @criteria_list = parse_criteria( criteria )

    # get editions list as an array
    @available_editions = *editions

    # set current date 
    current_date = Date.today

    # filter editions to retrieve only future ones
    @available_editions.filter! do |edition|
      # get only future editions with a valid date
      begin
        edition[:date].to_date > current_date 
      rescue
        # invalid date, ignore the entry
      end
    end
    
    # sort editions by date
    @available_editions.sort_by! {|edition| edition[:date] }
  end
  
  def available_editions
    @available_editions
  end
  
  def criteria_list
    @criteria_list
  end
  
  def editions 
    @editions
  end
  
  def run

    begin 
      @editions = []

      #process each available criteria     
      AVAILABLE_CRITERIA.each do |criteria|
      
        # get the data related to the criteria key
        criteria_data = @criteria_list[criteria]
      
        unless criteria_data.nil?
          case criteria
            when :closest
              if @available_editions.count > 0 
                # as available_editions is ordered by date 
                # the closest is the first one in the list
                closest_edition = @available_editions.first
                @editions = [ closest_edition ]
              end 
              
            when :latest
              if @available_editions.count > 0
                # as available_editions is ordered by date 
                # the latest is the last one in the list
                latest_edition = @available_editions.last
                @editions = [ latest_edition ]
              end
            
            when :type, :school
              if @available_editions.count > 0 
              
                # filter available options and left only those with 
                # courses that match the criteria_data (type or school)
                # use the destructive filter method to allow the use of additional 
                # criteria over this results (closest, latest)
                @available_editions.filter! do |edition|
                  if edition[:courses].map {|course| course[:type]}.include? criteria_data
                    edition[:courses].filter! {|course| course[:type].include? criteria_data }
                  end
                end
            
                @editions = @available_editions
              
              end
          end
        end
      end
  
      # use only the name attribute for courses list
      if @editions.count > 0  
        @editions.each do |edition|
          edition[:courses].map! {|course| course[:name]}
        end
      end
    
      return true

    rescue => e
      # something went wrong, print the error and return false
      # TODO propagate exception
      print e

      return false
      
    end
    
  end
  
private
  # get a list of the available keys and data in the criteria param
  def parse_criteria( criteria )
    criterias = *criteria

    parsed_criteria = {}
    
    criterias.each do |c|
      criteria_params = c.split("-")
      # the key is the first item in the list
      # the data is the rest of the items in the list

      # FIXME don't convert a value for a param directly into a symbol without check safe value
      criteria_key = criteria_params[0].to_sym
      criteria_data = criteria_params[1..].join("-")
      
      parsed_criteria[criteria_key] = criteria_data
    end    
    
    parsed_criteria
  end
  
end