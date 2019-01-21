Category.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('categories')
categories = [
  { internal_id: '1', name: 'Planning & Coordination', order_rank: 2},
  { internal_id: '2', name: 'Jewellery & Accessories', order_rank: 6},
  { internal_id: '3', name: 'Beauty', order_rank: 7},
  { internal_id: '4', name: 'Clothing', order_rank: 5},
  { internal_id: '5', name: 'Venue', order_rank: 1},
  { internal_id: '6', name: 'Film & Footage', order_rank: 9},
  { internal_id: '7', name: 'Styling & Decorations', order_rank: 3},
  { internal_id: '8', name: 'Entertainment', order_rank: 11},
  { internal_id: '9', name: 'Stationery', order_rank: 4},
  { internal_id: '10', name: 'Gifts & Favours', order_rank: 12},
  { internal_id: '11', name: 'Food & Drinks', order_rank: 10},
  { internal_id: '12', name: 'Transportation', order_rank: 13},
  { internal_id: '13', name: 'Celebrant', order_rank: 8},
  { internal_id: '14', name: 'Other', order_rank: 14},
]
categories.each do |category|
  obj = Category.find_or_initialize_by(internal_id: category[:internal_id])
  obj.attributes = category
  obj.save!
end


services_data = [
  {name: 'Planning', category: 'Planning & Coordination', order_rank: 1},
  {name: 'Coordination', category: 'Planning & Coordination', order_rank: 2},

  {name: 'Jewellery', category: 'Jewellery & Accessories', order_rank: 1},
  {name: 'Accessories', category: 'Jewellery & Accessories', order_rank: 2},

  {name: 'Makeup Trial', category: 'Beauty', order_rank: 1},
  {name: 'Hair Trial', category: 'Beauty', order_rank: 2},
  {name: 'Makeup', category: 'Beauty', order_rank: 3},
  {name: 'Hair', category: 'Beauty', order_rank: 4},

  {name: 'Bridalwear', category: 'Clothing', order_rank: 1},
  {name: 'Groomswear', category: 'Clothing', order_rank: 2},
  {name: 'Bridesmaids', category: 'Clothing', order_rank: 3},
  {name: 'Groomsmen', category: 'Clothing', order_rank: 4},
    {name: "Women's Footwear", category: 'Clothing', order_rank: 5},
    {name: "Men's Footwear", category: 'Clothing', order_rank: 6},
  {name: 'Juniorwear', category: 'Clothing', order_rank: 7},

  {name: 'Ceremony', category: 'Venue', order_rank: 1},
  {name: 'Reception', category: 'Venue', order_rank: 2},
  {name: 'Accommodation', category: 'Venue', order_rank: 3},

  {name: 'Photography', category: 'Film & Footage', order_rank: 1},
  {name: 'Videography', category: 'Film & Footage', order_rank: 2},

  {name: 'Floristry', category: 'Styling & Decorations', order_rank: 1},
  {name: 'Styling', category: 'Styling & Decorations', order_rank: 2},
  {name: 'Rental Hire', category: 'Styling & Decorations', order_rank: 3},

  {name: 'Save The Dates', category: 'Stationery', order_rank: 1},
  {name: 'Invitations', category: 'Stationery', order_rank: 2},
  {name: 'Stationery', category: 'Stationery', order_rank: 3},
    {name: 'Thank You Cards', category: 'Stationery', order_rank: 4},

  {name: 'Music', category: 'Entertainment', order_rank: 1},
  {name: 'Audio', category: 'Entertainment', order_rank: 2},
    {name: 'DJ', category: 'Entertainment', order_rank: 3},
  {name: 'Entertainment', category: 'Entertainment', order_rank: 4},
  {name: 'Lighting', category: 'Entertainment', order_rank: 5},
  {name: 'MC', category: 'Entertainment', order_rank: 6},

  {name: 'Gifts', category: 'Gifts & Favours', order_rank: 1},
    {name: 'Favours', category: 'Gifts & Favours', order_rank: 2},

  {name: 'Catering', category: 'Food & Drinks', order_rank: 1},
  {name: 'Beverage', category: 'Food & Drinks', order_rank: 2},
  {name: 'Cakes', category: 'Food & Drinks', order_rank: 3},

  {name: 'Transportation', category: 'Transportation'},
  {name: 'Celebrant', category: 'Celebrant'},
]

services_data.each do |data|
  service = Service.find_or_initialize_by(name: data[:name])
  service.attributes = data
  service.save!
end

default_todos = YAML.load_file(Rails.root.join('db', 'default_todos.yml'))['todos']
Todo.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('todos')

default_todos.each_with_index do |data, index|
  todo = Todo.find_or_initialize_by(name: data['name'])
  todo.attributes = data.except(*%w(suggestion_copy_female suggestion_copy_male timing category))
  todo.suggestion_copy = {
    bride: data['suggestion_copy_female'],
    groom: data['suggestion_copy_male'] || data['suggestion_copy_female']
  }
  timings = data['timing'].scan(/\d+/).map(&:to_i)
  todo.timing_min_month = timings.min
  todo.timing_max_month = timings.max
  todo.position = index + 1

  todo.service = Service.find_by_name(data['name'])

  todo.save!
end


locations = [
  'NSW',
  'VIC',
  'QLD',
  'WA',
  'ACT',
  'NT',
  'TAS',
  'SA',
  'Australia Wide',
  'International',
]
locations.each do |loc|
  location = Location.find_or_initialize_by(name: loc, vendor: nil)
  location.save!
end


default_features = [
  {id: 1, name: 'Couple Referrals', status: 1},
  {id: 2, name: 'Business Referrals', status: 1},
  {id: 3, name: 'Couple Rewards', status: 1},
]
default_features.each do |data|
  feature = Feature.find_or_initialize_by(name: data[:name])
  feature.attributes = data
  feature.save!
end
