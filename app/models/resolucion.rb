class Resolucion < ActiveRecord::Base

  self.table_name="resoluciones"
  self.primary_key = 'id'
 
  attr_accessible :id, :numero, :descripcion, :fecha_emision, :tipo_resolucion_id, :data, :habilitado
  belongs_to :tipo_resolucion
  
  scope :orden_id, -> {order("id")}
  has_attached_file :data
  validates_attachment_content_type :data, :content_type => ['application/pdf', 'application/binary']
 
end