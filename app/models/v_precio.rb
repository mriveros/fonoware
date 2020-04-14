class VPrecio < ActiveRecord::Base
  
  self.table_name= "v_precios"
  self.primary_key = "id"
  
  attr_accessible :id, :descripcion, :predeterminado
 
  scope :predeterminado, -> { order("predeterminado = 't' desc")}

  
end