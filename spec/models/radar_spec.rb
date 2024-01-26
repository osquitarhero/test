require 'rails_helper'


RSpec.describe Radar, type: :model do

  # generate two datos for editions 3 and 6 months from current date
  first_edition_date = (Date.today+3.months).strftime("%Y-%m-%d")
  second_edition_date = (Date.today+6.months).strftime("%Y-%m-%d")

  params = {"criteria":["closest","school-cooperacion"],"editions":[{"date": first_edition_date ,"courses":[{"name": "Especialista en cooperación internacional","type": "cooperacion"},{"name": "Divulgación y cooperación de la ciencia","type": "divulgacion-cientifica"}]},{"date": second_edition_date,"courses":[{"name": "Comprendiendo el portugués","type": "portugues"},{"name": "Competencias digitales para la educación","type": "competencias-digitales"}]}]}
      
  radar = Radar.new( params[:criteria], params[:editions])

  it "params load" do     
    
    expect(radar.criteria_list.count).to eq( 2 )
    expect(radar.available_editions.count).to eq(2)
    expect(radar.available_editions.first[:courses].count).to eq(2)
    expect(radar.available_editions.last[:courses].count).to eq(2)
    
    
  end
  
  it "radar run" do
    expect(radar.run).to eq( true )
    expect(radar.editions).to eq( [{:date=> first_edition_date, :courses=>["Especialista en cooperación internacional"]}] )
  end

end
