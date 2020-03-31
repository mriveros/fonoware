class Curso < ActiveRecord::Base
  
  scope :orden_id, -> { order('id')}
  scope :basica, -> {where('id in (1,2,3,4,5,6,7,8,9,10,11,12,13)')}
  scope :media, -> {where('id in (14,15,16,25,26,27)')}
 
end