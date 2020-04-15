class VCita < ActiveRecord::Base

  self.table_name="v_citas"
  self.primary_key="cita_id"
  
  attr_accessible :cita_id, :fecha_cita, :paciente_id, :paciente_documento, :paciente_nombre, :paciente_apellido, :profesional_id, :profesional_nombre, :profesional_apellido, :tipo_consulta_id, :tipo_consulta, :especialidad_id, :especialidad, :precio_id, :precio, :observacion, :created_at, :updated_at
  
  scope :orden_01, -> { order("fecha_cita")}
  scope :orden_fecha_cita_actual, -> { where("fecha_cita = now() ")}
  scope :orden_fecha_cita, -> { order("fecha_cita desc")}
  scope :fonoaudiologia, -> { where("especialidad_id = ?", PARAMETRO[:especialidad_fonoaudiologia])}
  
end