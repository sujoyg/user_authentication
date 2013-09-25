# Adapted from http://my.rails-royce.org/2010/07/21/email-validation-in-ruby-on-rails-without-regexp/

require 'mail'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    email = Mail::Address.new(value)
    valid = email.domain && email.address == value && email.__send__(:tree).domain.dot_atom_text.elements.size > 1 rescue false
    record.errors[attribute] << (options[:message] || 'is malformed') unless valid
  end
end