# frozen_string_literal: true

[
  {
    name:        'A Good Pone',
    description: 'Give somepone a point!'
  },
  {
    name:        'Somepone Likes You!',
    description: 'Receive points from the same pone at least 3 days in a row.'
  },
  {
    name:        'The Regular',
    description: 'Give out points at least 3 days in a row.'
  },
  {
    name:        'Counterpoint',
    description: "Give a pone a point immediately after you've received one from them."
  },
  {
    name:        'The Groupie',
    description: 'Join a group!'
  },
  {
    name:        'Cult Leader',
    description: 'Create a group and have at least 9 other pones join it.'
  }
].each do |attributes|
  name = attributes.delete(:name)

  Achievement.find_or_create_by!(name: name) do |achievement|
    achievement.attributes = attributes
  end
end
