class Cita < ActiveRecord::Base

  self.table_name="citas"
  self.primary_key="id"
  
  attr_accessible :id, :fecha_cita, :paciente_id, :profesional_id, :tipo_consulta_id, :especialidad_id, :precio_id, :observacion, :created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  scope :fonoaudiologia, -> { where("especialidad_id = ?", PARAMETRO[:especialidad_fonoaudiologia])}
  
end