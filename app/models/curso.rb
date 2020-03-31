class Curso < ActiveRecord::Base
  
  scope :orden_id, -> { order('id')}
  scope :basica, -> {where('id in (9,20,21,22,23,24,25,26,27,28,29,30,31,32,33)')}
  scope :media, -> {where('id in (14,15,16,25,26,27)')}
 
end