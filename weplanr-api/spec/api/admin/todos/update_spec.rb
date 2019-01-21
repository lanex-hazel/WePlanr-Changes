require 'rails_helper'

describe 'PATCH /admin/todos/:id' do

  let(:obj) { Todo.first }

  let(:valid_params) do
    {
      data: {
        type: 'todos',
        id: obj.id,
        attributes: {
          name: 'woot'
        }
      }
    }
  end

  it 'returns status 200' do
    auth_patch "/api/admin/todos/#{obj.id}", valid_params
    expect(response.status).to eq 200
  end

  it 'changes db' do
    auth_patch "/api/admin/todos/#{obj.id}", valid_params

    obj.reload
    expect(obj.name).to eq 'woot'
  end

end

