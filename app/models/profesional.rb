class Profesional < ActiveRecord::Base

  self.table_name="profesionales"
  self.primary_key="id"
  
  attr_accessible :id, :persona_id
  
  scope :orden_01, -> { order("id")}
  
end