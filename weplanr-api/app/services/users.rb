module Users
  class Booking

    attr_accessor :wedding, :collection
    def initialize wedding
      @wedding = wedding
      @collection = []
    end

    def list
      system_booking
      custom_booking
      collection
    end

    def system_booking
      wedding.bookings.each do |booking|
        entry = booking_format booking
        collection.push entry
      end
    end

    def custom_booking
      wedding.outside_vendors.each do |booking|
        entry = custom_booking_format booking
        collection.push entry
      end
    end

    def booking_format booking
      {
        id: booking.id,
        type: 'Booking',
        quote_no: booking.quote.quote_no,
        vendor: {
          business_name: booking.vendor.business_name,
          address_summary: booking.vendor.address_summary,
          slug: booking.vendor.slug,
          profile_photo: booking.vendor.profile_photo.url
        },
        todo: if booking.todos.present?
            default_todo booking.todos
          elsif booking.custom_todos.present?
            custom_todo booking.custom_todos
          end
      }
    end

    def custom_booking_format booking
      {
        id: booking.id,
        type: 'CustomBooking',
        quote_no: nil,
        vendor: {
          business_name: booking.business_name,
          address_summary: booking.address_summary,
          slug: nil,
          profile_photo: nil
        },
        todo: if booking.todos.present?
            default_todo booking.todos
          elsif booking.custom_todos.present?
            custom_todo booking.custom_todos
          end
      }
    end

    def default_todo obj
      {
        id: obj.first.id,
        type: 'Todo',
        name: obj.pluck(:name).join('')
      }
    end

    def custom_todo obj
      {
        id: obj.first.id,
        type: 'CustomTodo',
        name: obj.pluck(:name).join('')
      }
    end

  end
end