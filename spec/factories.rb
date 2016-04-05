FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "dummy-email#{n}@domain.com"}
    password "test_pass"
  end

  factory :gram do
    message "Gram stuff"
    image {File.open "#{Rails.root}/spec/support/sample.jpg"}
    association :user
  end

  factory :comment do
    message "Comment stuff"
    association :user
    association :gram
  end
end