class RadarController < ApplicationController
  # Get available courses from a courses list for a given criteria
  # https://github.com/oei-int/code-test/
  # params:
  #     criteria: criteria for course selection
  #     editions: list of available courses including date, name and course type 
  # return:
  #     list of course that match the criteria
  def get_courses
        
    # TODO permit only safe params
    #courses_params = params.permit(:criteria, editions: [:date, courses: [:name, :type]  ])
    
    if params[:criteria] && params[:editions]

      radar = Radar.new( params[:criteria], params[:editions])
    
      # create a new radar class with criteria and editions
      logger.info "#{radar.criteria_list.count } criteria:"
      logger.info radar.criteria_list
    
      logger.info "#{radar.available_editions.count } avaliable editions:"
      logger.info radar.available_editions
  
    
      if radar.run 
        logger.info "#{radar.editions.count} retrieved courses"
        logger.info radar.editions
      
        render json: radar.editions, status: 200  
      else 
        # TODO include the error message in the response
        render status: 500
      end
      
    else
      render json: {error: "invalid params"}, status: 404
    end
    
  end
  
end
