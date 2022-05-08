class EventValidation

    #TODO: validation
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :id, :title, :description, :active, :scheduledAtTime, :scheduledAtDate, :scheduledAt, :creator, :invitees

    validates :title, :description, :active, :scheduledAt, :creator, :invitees, :scheduledAtTime, :scheduledAtDate, presence: true

end
