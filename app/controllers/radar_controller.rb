class RadarController < ApplicationController
  # Get available courses from a courses list for a given criteria
  # https://github.com/oei-int/code-test/
  # params:
  #     criteria: criteria for course selection
  #     editions: list of available courses including date, name and course type 
  # return:
  #     list of course that match the criteria
  def get_courses
    
    # TODO permit only know params
    #courses_params = params.permit(:criteria, editions: [:date, courses: [:name, :type]  ])


    # available criterias and evaluation priority
    # as filters can be additional to each others
    # process first those that could return multiple results (type and school)
    # FIXME just for development purposes
    available_criteria = %i[ type school latest closest]
    
    # get editions list as an array
    available_editions = *params[:editions]

    # set current date 
    current_date = Date.today

    # filter editions to retrieve only future ones
    available_editions.filter! do |edition|
      # get only future editions with a valid date
      begin
        edition[:date].to_date > current_date 
      rescue
        # invalid date, ignore the entry
      end
    end
    
    # sort editions by date
    available_editions.sort_by! {|edition| edition[:date] }
    
    logger.info("Future editions: #{available_editions.count }")

    # get criteria list 
    criteria_list = parse_criteria( params[:criteria] )
  
    editions = []
    #process each available criteria     
    available_criteria.each do |criteria|
      
      # get the data related to the criteria key
      criteria_data = criteria_list[criteria]
      
      unless criteria_data.nil?
        logger.info "Processing criteria '#{ criteria }#{ criteria_data.empty? ? '' : '-' + criteria_data}'"
          
        case criteria
          when :closest
            if available_editions.count > 0 
              # as available_editions is ordered by date 
              # the closest is the first one in the list
              closest_edition = available_editions.first
              editions = [ closest_edition ]
            end 
              
          when :latest
            if available_editions.count > 0
              # as available_editions is ordered by date 
              # the latest is the last one in the list
              latest_edition = available_editions.last
              editions = [ latest_edition ]
            end
            
          when :type, :school
            if available_editions.count > 0 
              
              # filter available options and left only those with 
              # courses that match the criteria_data (type or school)
              # use the destructive filter method to allow the use of additional 
              # criteria over this results (closest, latest)
              available_editions.filter! do |edition|
                if edition[:courses].map {|course| course[:type]}.include? criteria_data
                  edition[:courses].filter! {|course| course[:type].include? criteria_data }
                end
              end
            
              editions = available_editions
              
            end
        end
      end
    end
  
    if editions.count > 0 
      editions.each do |edition|
        edition[:courses].map! {|course| course[:name]}
      end
    end
  
     
    render json: editions, status: 200  
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

      # TODO don't convert a value for a param directly into a symbol without check safe value
      criteria_key = criteria_params[0].to_sym
      criteria_data = criteria_params[1..].join("-")
      
      parsed_criteria[criteria_key] = criteria_data
    end    
    
    parsed_criteria
  end
  
end
