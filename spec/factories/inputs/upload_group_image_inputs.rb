# frozen_string_literal: true

FactoryBot.define do
  factory :upload_group_image_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    group { create(:group) }
    image { Rack::Test::UploadedFile.new(image_file_path, 'image/png') }

    transient do
      image_file_path { Rails.root.join('spec', 'support', 'avatar.png') }
    end

    trait :invalid do
      image { nil }
    end
  end
end
