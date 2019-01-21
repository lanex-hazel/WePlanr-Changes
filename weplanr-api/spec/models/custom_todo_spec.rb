require 'rails_helper'

describe CustomTodo do

  it 'it is valid with valid attributes' do
    expect(auth_user.wedding.custom_todos.new(name: 'Rehearsal Dinner', status: 'booked')).to be_valid
  end

  it 'it is not valid without a name' do
    expect(auth_user.wedding.custom_todos.new(name: '')).to_not be_valid
  end
end