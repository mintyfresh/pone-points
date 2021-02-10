# frozen_string_literal: true

RSpec::Matchers.define :match_schema do |schema|
  match do |response|
    schema_path   = "#{Dir.pwd}/schema/#{schema}.schema.json"
    response_body = response.is_a?(String) ? response : response.body
    @result = JSON::Validator.fully_validate(schema_path, response_body)

    @result.blank?
  end

  failure_message do |actual|
    "expected #{actual} to match response schema #{schema}\n." + @result.join('. ')
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to match response schema #{schema}\n." + @result.join('. ')
  end
end
