class CitaDetalleFono < ActiveRecord::Base

  self.table_name="citas_detalles_fono"
  self.primary_key="id"
  
  attr_accessible :id, :cita_id, :objetivo, :estrategia, :resultado, :observacion, :resolucion_id, :created_at, :updated_at
  
  scope :orden_01, -> { order("id")}
  
end