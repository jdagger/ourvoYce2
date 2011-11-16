class StateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless State.where(:abbreviation => value.to_s).count == 1
      record.errors[attribute] << (options[:message] || "is not a valid state")
    end
  end
end
