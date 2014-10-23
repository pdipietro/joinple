# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :share do
    from_user_id 1
    to_user_id 1
    to_email "MyString"
    created_at "2014-10-16 20:21:58"
    url "MyString"
  end
end
