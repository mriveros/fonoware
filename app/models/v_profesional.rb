class VProfesional < ActiveRecord::Base

  self.table_name="v_profesionales"
  self.primary_key="id_paciente"
  
  attr_accessible :id_profesional, :documento_persona, :nombre_persona, :apellido_persona, :tipo_documento_id, :tipo_documento, :fecha_nacimiento, :nacionalidad_id, :nacionalidad,  :direccion, :telefono, :celular, :correo_electronico
 
  scope :orden_01, -> { order("paciente_id")}

  
end