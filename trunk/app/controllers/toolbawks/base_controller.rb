class Toolbawks::BaseController < ApplicationController
  before_filter :login_required
	before_filter :check_authorization
  
  private 
  
  def association_config(klass, core_model)
    config = false
    
    # If we have defined what association passed through, use that
    if klass.include?('.')
      klass, collection = klass.split('.')
    end
    
    # Verify that the klass passed in is indeed a class
    begin
      model = Kernel.const_get(klass)
    rescue
      logger.info 'Toolbawks::Base.association_config -> Unable to locate klass: ' + klass
      return config
    end
  
    if collection && model.reflections.collect { |r| r[1].name.to_s }.index(collection)
      # Get the association for the passed collection
      association = model.reflections.collect[model.reflections.collect { |r| r[1].name.to_s  }.index(collection)][1]
    elsif model.reflections.collect { |r| r[1].class_name }.index(core_model.to_s)
      # Check the association exists between the model and the Asset 
      # based on the association type passed
      association = model.reflections.collect[model.reflections.collect { |r| r[1].class_name }.index(core_model.to_s)][1]
    else
      # No association found with this model
      logger.info 'Toolbawks::Base.association_config -> Unable to locate association: ' + klass + ' for model:' + core_model.to_s
      return config
    end
  
    # Get the table name of the association
    table_name = association.options[:join_table]
  
    # Get the column to match the association in the table
    association_column = association.primary_key_name
  
    config = {
      :table => table_name,
      :column => association_column,
      :association => association,
      :model => model
    }
  end
end