class PasswordValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        if to_short(value)
            record.errors.add(attribute, "needs to be 8 characters or more")
        end
    end

    def to_short(value)
        value.length < 8
    end
end

