module ArraySerializer
  extend ActiveSupport::Concern

  def serialize_array records = collection, each_serializer = serializer, meta = {}
    {
      meta: meta,
      data: records.map do |obj|
        serialize_obj(obj, each_serializer)
      end
    }
  end

  def serialize_array_with_errors records = collection, each_serializer = serializer, meta = {}
    {
      meta: meta,
      data: records.map do |obj|
        json = serialize_obj(obj, each_serializer)
        json[:errors] = obj.errors.full_messages if obj.errors.any?

        json
      end
    }
  end

  def serialize_obj obj, serializer
    {
      id: obj.id,
      type: obj.class.name,
      attributes: serializer.new(obj).as_json
    }
  end
end
