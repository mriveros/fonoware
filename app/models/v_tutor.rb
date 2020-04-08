class VTutor < ActiveRecord::Base

  self.table_name="v_tutores"
  self.primary_key="tutor_id"
  
  attr_accessible :tutor_id, :documento_persona, :nombre_persona, :apellido_persona, :tipo_documento_id, :tipo_documento, :fecha_nacimiento, :nacionalidad_id, :nacionalidad,  :direccion, :telefono, :celular, :correo_electronico
 
  scope :orden_01, -> { order("tutor_id")}

  
end