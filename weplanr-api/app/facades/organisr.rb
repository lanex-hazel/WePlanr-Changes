class Organisr
  attr_accessor :wedding, :filter_loaded_associate


  def initialize wedding, filter_loaded_associate=[]
    @wedding = wedding
    @filter_loaded_associate = filter_loaded_associate
  end

  def todos
    data = Todo.all + wedding.custom_todos

    # sort & wrap
    data.sort_by{ |v| v.service_id || 0 }.map{ |todo| decorate(todo) }
  end

  def decorate todo
    todo_class = todo.is_a?(Todo) ? DefaultTodo : CustomTodo
    todo_class.new(todo, wedding, db_cache)
  end

  def db_cache
    @_db_cache ||= DbCache.new(wedding, filter_loaded_associate)
  end


  class DbCache
    # TODO:
    #   key on #find should be derived here on class
    #   and should be configured here on ASSOCIATION_KEYS
    ASSOCIATION_KEYS = {
      bookings:        {key: :id, preload: :quote},
      outside_vendors: {key: :id},
      budgets:         {key: :todo_id},
      todo_statuses:   {key: :todo_id},
    }

    def initialize wedding, filter_loaded_associate
      @wedding = wedding
      load_cache(filter_loaded_associate)
    end

    def find group_name, key
      group = get(group_name)
      group && group[key]
    end

    def get name
      instance_variable_get("@#{name}")
    end

    def set name, value
      instance_variable_set("@#{name}", value)
    end

    def load_cache filter_loaded_associate=[]
      set('services', Hash[*Service.primary.map{ |s| [s.id, s] }.flatten])

      selected_keys =
        if filter_loaded_associate.any?
          ASSOCIATION_KEYS.select{ |key,v| filter_loaded_associate.include?(key) }
        else
          ASSOCIATION_KEYS
        end

      selected_keys.each do |group_name, config|
        data = @wedding.send(group_name).preload(config[:preload])

        cache = {}
        data.each do |obj|
          key = obj.send(config[:key])
          cache[key] = obj
        end

        set(group_name, cache)
      end
    end

  end


  class BaseTodo
    attr_accessor :todo, :wedding, :associations

    def initialize todo, wedding, associations
      @todo = todo
      @wedding = wedding
      @associations = associations
    end

    def vendor
      @_vendor ||= booking&.vendor
    end

    def service
      associations.find('services', service_id) if service_id
    end

    def quote
      @_quote ||= booking&.quote
    end

    def actual
      if outside_vendor
        outside_vendor.total_fee
      elsif quote
        quote.total
      else
        0
      end
    end

    def paid
      if outside_vendor
        outside_vendor.paid
      elsif quote
        quote.total_paid
      else
        0
      end
    end

    def notes
      @_notes ||= wedding.todo_notes.where(noteable: todo).first.try(:content) || ''
    end

    # for ActiveModel::Serializer
    def read_attribute_for_serialization method
      send method
    end

    def method_missing method, *args, &block
      todo.send method, *args, &block
    end
  end


  class DefaultTodo < BaseTodo

    def read_attribute_for_serialization method
      if method.eql? :id
        (budget || todo).id
      else
        super
      end
    end

    def status_model
      #@_status_model ||= wedding.todo_statuses.find_by_todo_id(id)
      @_status_model ||= associations.find('todo_statuses', id)
    end

    def status
      @_status ||= status_model&.status || 'pending'
    end

    def budget
      #@_budget ||= wedding.budgets.find_by_todo_id(todo.id)
      @_budget ||= associations.find('budgets', id)
    end
      
    def booking
      #@_booking ||= status_model&.booking
      @_booking ||= status_model&.booking_id && associations.find('bookings', status_model.booking_id)
    end

    def outside_vendor
      #@_outside_vendor ||= status_model&.vendor
      @_outside_vendor ||= status_model&.outside_vendor_id && associations.find('outside_vendors', status_model.outside_vendor_id)
    end

    def planned
      budget ? budget.planned : 0
    end

    def service_name; nil; end
  end


  class CustomTodo < BaseTodo

    def booking
      #@_booking ||= todo.booking
      @_booking ||= booking_id && associations.find('bookings', booking_id)
    end

    def outside_vendor
      #@_outside_vendor ||= todo.outside_vendor
      @_outside_vendor ||= outside_vendor_id && associations.find('outside_vendors', outside_vendor_id)
    end

    def position
      999 * id
    end
  end

end
