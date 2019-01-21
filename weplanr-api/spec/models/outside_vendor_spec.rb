require 'rails_helper'

describe CustomTodo do

  context 'after_create' do

    let(:default_params) do
      {
        business_name: 'asd',
        address_summary: 'asd',
        total_fee: 123
      }
    end

    it 'links to custom_todo' do
      custom_todo = CustomTodo.create(name: 'custom todo', wedding: auth_user.wedding)
      obj = OutsideVendor.create(default_params.merge custom_todo_id: custom_todo.id, wedding: auth_user.wedding)

      expect(custom_todo.reload.outside_vendor).to eq obj
    end

    it 'links to budget' do
      budget = Budget.create(todo: Todo.first, wedding: auth_user.wedding)
      obj = OutsideVendor.create(default_params.merge budget_id: budget.id, wedding: auth_user.wedding)

      expect(budget.todo_status.outside_vendor).to eq obj
    end

  end

  let!(:outside_vendor) { auth_user.wedding.outside_vendors.create business_name: 'PadSource', address_summary: 'Manila', total_fee: 20.0 }
  let!(:todo) { Todo.find 1 }

  it 'it is valid with valid attributes' do
    expect(auth_user.wedding.outside_vendors.new(
        business_name: 'PadSource',
        address_summary: 'Manila',
        total_fee: 20.0
      )).to be_valid
  end

  it 'it is not valid without a business_name' do
    expect(auth_user.wedding.outside_vendors.new(
      public_contact_name: 'PadSource',
      address_summary: 'Manila',
      total_fee: 20.0
    )).to_not be_valid
  end

  it 'it is not valid without a address_summary' do
    expect(auth_user.wedding.outside_vendors.new(
      business_name: 'PadSource',
      email: 'padsource@email.com',
      total_fee: 20.0
    )).to_not be_valid
  end

  it 'it is not valid without a total_fee' do
    expect(auth_user.wedding.outside_vendors.new(
      business_name: 'PadSource',
      address_summary: 'Manila',
      email: 'padsource@email.com'
    )).to_not be_valid
  end

  context '.link_to_defaulttodo' do
    it 'should insert a row in todo_statuses' do
      
      outside_vendor.link_to_defaulttodo todo, auth_user.wedding
      todo_status = TodoStatus.last
      expect(TodoStatus.count).to eq 1
      expect(todo_status.outside_vendor_id).to eq outside_vendor.id
    end
  end
end
