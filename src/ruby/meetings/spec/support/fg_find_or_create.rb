module FactoryGirl::Syntax::Methods
  def find_or_create(name, attributes = {}, &block)
    factory = FactoryGirl.factory_by_name(name)
    klass   = factory.build_class

    factory_attributes = FactoryGirl.attributes_for(name)
    attributes = factory_attributes.merge(attributes)

    result = klass.find_by(attributes, &block)

    if result
      result
    else
      FactoryGirl.create(name, attributes, &block)
    end
  end
end
