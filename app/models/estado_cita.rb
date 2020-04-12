class EstadoCita < ActiveRecord::Base

  self.table_name="estados_citas"
  self.primary_key="id"
  
  attr_accessible :id, :descripcion, :especialidad_id, :created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  scope :fonoaudiologia, -> { where("especialidad_id = ?", PARAMETRO[:especialidad_fonoaudiologia])}
  
end