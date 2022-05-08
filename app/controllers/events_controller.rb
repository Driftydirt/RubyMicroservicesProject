class EventsController < ApplicationController
    def new
        @new_event_validation = EventValidation.new
        @new_event_error = ""
    end
    
    def edit
        @update_event_validation = EventValidation.new
        @update_event_error = ""
    end


    def generate_event
        @new_event_validation = EventValidation.new(params["new_event_validation"].permit(:title, :description, :active, :scheduledAtTime, :scheduledAtDate, :creator, :invitees))
        invitees_string = params["new_event_validation"]["invitees"].split(",")
        invitees = []
        invitees_string.each do |i|
            invitees.push(i.to_i)
        end
        puts [invitees]
        @new_event_validation.invitees = invitees
        @new_event_validation.scheduledAt = "#{@new_event_validation.scheduledAtDate} #{@new_event_validation.scheduledAtTime}".to_datetime
        if @new_event_validation.valid?
            create_event(@new_event_validation)
            redirect_to root_path
        else
            puts @new_event_validation.errors.full_messages
            render 'new', status: :unprocessable_entity
        end
    end

    def update_generated_event
        @update_event_validation = EventValidation.new(params["update_event_validation"].permit(:id, :title, :description, :active, :scheduledAt, :creator, :invitees))
        if @update_event_validation.valid?
            update_event(@update_event_validation)
        else
            puts @update_event_validation.errors.full_messages
            render 'new', status: :unprocessable_entity
        end
    end
    
end