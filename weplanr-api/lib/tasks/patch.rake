namespace :patch do
  desc 'New TODOs'
  # coding from seeds.db
  task new_todos: :environment do
    # prepare services
    category = Category.where(name: 'Beauty').first
    category.services.order(:order_rank).each{|service| service.update_column(:order_rank, service.order_rank+2)}

    [
      {name: 'Makeup Trial', category: 'Beauty', order_rank: 1},
      {name: 'Hair Trial', category: 'Beauty', order_rank: 2}
    ].each do |data|
      service = Service.find_or_initialize_by(name: data[:name])
      service.attributes = data
      service.save!
    end

    # insert as todos
    default_todos = YAML.load_file(Rails.root.join('lib', 'tasks', 'todos.yml'))['todos']

    default_todos.each do |data|
      todo = Todo.find_or_initialize_by(name: data['name'])
      todo.attributes = data.except(*%w(suggestion_copy_female suggestion_copy_male timing category))
      todo.suggestion_copy = {
        bride: data['suggestion_copy_female'],
        groom: data['suggestion_copy_male'] || data['suggestion_copy_female']
      }
      timings = data['timing'].scan(/\d+/).map(&:to_i)
      todo.timing_min_month = timings.min
      todo.timing_max_month = timings.max

      todo.service = Service.find_by_name(data['name'])

      todo.save!
    end

    # insert new todos to existing 
    trial_todos = Todo.where(name: ['Makeup Trial', 'Hair Trial'])

    Wedding.order(:id).each do |wedding|
      trial_todos.each do |todo|
        current_state = wedding.todo_statuses.where(todo: todo).take
        guide = (wedding.budget * todo.budget_percent / 100.0).round
        obj = wedding.budgets.find_or_initialize_by(todo: todo)
        obj.guide = guide
        obj.planned = guide if todo.is_initial_plan && current_state&.status != 'removed'
        obj.save
      end
    end

    # update todo position
    makeup_todo = Todo.where(name: 'Makeup').first
    Todo.order(:id).each do |todo| 
      todo.update_column(:position, (todo.id >= makeup_todo.id ? todo.id + 2 : todo.id)) #14 is id of MakeUp
    end

    trial_todos.each_with_index do |todo, index| 
      todo.update_column(:position, 14 + index) #14 is id of MakeUp
    end
  end

  desc 'Map old todo ids to new Organisr todo ids'
  task map_organisr_ids: :environment do
    new_id_mapping = {
      1 => 1,
      2 => 2,
      3 => 4,
      4 => 5,
      5 => 6,
      6 => 8,
      7 => 9,
      8 => 10,
      9 => 11,
      10 => 12,
      11 => 13,
      12 => 14,
      13 => 15,
      14 => 16,
      15 => 17,
      16 => 18,
      17 => 19,
      18 => 20,
      #19 => 22,
      20 => 22,
      21 => 23,
      22 => 24,
      23 => 25,
      24 => 26,
      25 => 27,
      26 => 28,
      27 => 30,
      28 => 31,
      #29 => 31,
      30 => 32,
      31 => 33,
      #32 => 32,
      #33 => 33,
      34 => 35,
      35 => 34,
      36 => 37,
      37 => 38,
    }

    removed_todos = [19, 29, 32, 33]

    Budget.all.each do |obj|
      if removed_todos.include? obj.todo_id
        obj.destroy
      else
        obj.update(todo_id: new_id_mapping[obj.todo_id])
      end
    end

    TodoStatus.all.each do |obj|
      if removed_todos.include? obj.todo_id
        obj.destroy
      else
        obj.update(todo_id: new_id_mapping[obj.todo_id])
      end
    end
  end

  desc 'Update old primary service to category'
  task update_internal_ids: :environment do
    mapping = {
      2 => 5,
      4 => 9,
      5 => 6,
      6 => 6,
      8 => 3,
      12 => 7,
      13 => 7,
      14 => 4,
      18 => 13,
      19 => 11,
      20 => 11,
      21 => 8,
      22 => 1,
      24 => 2,
      28 => 14,
      31 => 7,
      33 => 1,
      34 => 2
    }

    # clear internal_id's
    Vendor.update_all(internal_id: nil)

    Vendor.all.each do |v|
      new_primary_service_id = mapping[v.primary_service_id]
      v.update primary_service_id: new_primary_service_id
    end
  end

  desc 'For organisr intro mapping'
  task update_services: :environment do
    Service.find_by_name('Footwear').update_column(:name, "Women's Footwear")
    Service.find_by_name('Others').destroy
    #Service.where(name: ['LGBTQ+', 'Same Sex Marriage']).destroy_all
  end

  desc 'Clean service tags'
  task destroy_service_tags: :environment do
    ActsAsTaggableOn::Tagging.where(taggable_type: 'Service').destroy_all
  end

  task update_weddings: :environment do
    Wedding.all.each do |wedding|
      wedding.send :breakdown_budget
      wedding.update_outstanding_todo
    end
  end

  task backup_users: :environment do
    Wedding.all.each do |wedding|
      CSV.open("users_data/#{wedding.name}_#{wedding.users.map(&:email).compact.join('-')}.csv", "w") do |csv|

        csv << [wedding.name]
        csv << wedding.users.map(&:email).compact
        csv << [] # new line

        csv << ['Budgets', "Total: #{wedding.budget}"]
        csv << ['Name', 'Planned', 'Actual', 'Paid', 'Owing']
        wedding.budgets.includes(:todo).each do |b|
          todo_state = wedding.todo_statuses.find_by_todo_id(b.todo_id)

          is_removed = todo_state.present? && todo_state.status == 'removed'
          next if is_removed

          is_booked = todo_state&.booking
          is_customVendor = todo_state&.outside_vendor

          actual =
            if is_booked
              is_booked.quote&.total.ceil
            elsif is_customVendor
              is_customVendor.total_fee.ceil
            else
              0
            end

          paid =
            if is_booked
              is_booked.quote&.total_paid.ceil
            elsif is_customVendor
              is_customVendor.paid.ceil
            else
              0
            end

          owing = actual - paid

          csv << [b.todo.name, b.planned, actual, paid, owing]
        end
        csv << [] # new line

        csv << ['Updated Todos']
        todo_statuses = TodoStatus.includes(:todo).where(wedding: wedding)
        todo_statuses.map do |ts|
          csv << [ts.todo.name, ts.status]
        end
        csv << [] # new line

        csv << ['Bookings'] if wedding.bookings.any?
        wedding.bookings.map do |b|
          csv << [b.vendor.business_name]
        end
      end
    end
  end

  task backup_vendors: :environment do
    Vendor.includes(:services).each do |vendor|
      CSV.open("vendors_data/#{vendor.id}_#{vendor.business_name}.csv", "w") do |csv|

        csv << [vendor.business_name]
        csv << ['Internal ID', vendor.internal_id]
        csv << [] # new line

        csv << ['Primary Service ID', vendor.primary_service_id]
        csv << ['Primary Service', vendor.primary_service_id && Service.find(vendor.primary_service_id)&.name]
        csv << [] # new line

        csv << ['Services']
        vendor.services.each do |s|
          csv << [s.name]
        end
        csv << [] # new line

        csv << ['Custom Tags']
        vendor.tag_list.each do |tag|
          csv << [tag]
        end
      end
    end
  end

end
