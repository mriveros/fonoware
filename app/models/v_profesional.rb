class VProfesional < ActiveRecord::Base

  self.table_name="v_profesionales"
  self.primary_key="profesional_id"
  
  attr_accessible :profesional_id, :documento_persona, :nombre_persona, :apellido_persona, :tipo_documento_id, :tipo_documento, :fecha_nacimiento, :nacionalidad_id, :nacionalidad,  :direccion, :telefono, :celular, :correo_electronico
 
  scope :orden_01, -> { order("profesional_id")}

  
end