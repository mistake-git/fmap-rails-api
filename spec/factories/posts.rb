FactoryBot.define do
  factory :post do
    user_id {1}
    name { 'タイ' }
    number {1}
    latitude {135}
    longitude {35}
  end
end