require 'rails_helper'

describe 'POST /todos/:id/notes' do
  it 'creates todo note for default Todo' do
    todo = Todo.first
    expect {
      auth_post ['/api/todos/', todo.id , '/notes'].join, post_params(todo)
    }.to change{ TodoNote.count }.by 1
  end

  it 'creates todo note for custom Todo' do
    todo = auth_user.wedding.custom_todos.create(name: 'foo')
    expect {
      auth_post ['/api/todos/', todo.id , '/notes'].join, post_params(todo)
    }.to change{ TodoNote.count }.by 1
  end

  it 'wont create duplicate note per todo' do
    todo = auth_user.wedding.custom_todos.create(name: 'foo')
    expect {
      auth_post ['/api/todos/', todo.id , '/notes'].join, post_params(todo)
      auth_post ['/api/todos/', todo.id , '/notes'].join, post_params(todo)
    }.to change{ TodoNote.count }.by 1
  end

  def post_params obj
    {
      data: {
        attributes: {
          noteable_id: obj.id,
          noteable_type: obj.class.to_s,
          content: 'foo'          
        }
      }
    }
  end
end