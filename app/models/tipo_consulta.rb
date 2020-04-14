class TipoConsulta < ActiveRecord::Base

  self.table_name="tipos_consultas"
  self.primary_key="id"
  
  attr_accessible :id, :descripcion, :especialidad_id ,:created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  scope :especialidad_fonoaudiologia, -> { where("especialidad_id = ?", PARAMETRO[:especialidad_fonoaudiologia])}
  
end